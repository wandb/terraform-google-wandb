provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.default.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.default.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 13.0"
  project_id                  = null
  disable_dependent_services  = false
  disable_services_on_destroy = false
  activate_apis = [
    "iam.googleapis.com",               // Service accounts
    "logging.googleapis.com",           // Logging
    "sqladmin.googleapis.com",          // Database
    "networkmanagement.googleapis.com", // Networking
    "servicenetworking.googleapis.com", // Networking
    "redis.googleapis.com",             // Redis
    "pubsub.googleapis.com",            // File Storage
    "storage.googleapis.com",           // Cloud Storage
    "cloudkms.googleapis.com",          // KMS
    "compute.googleapis.com",           // required for datadog monitoring
    "cloudasset.googleapis.com",        // required for datadog monitoring
    "secretmanager.googleapis.com"      // required for secrets
  ]
}

locals {
  fqdn              = var.subdomain == null ? var.domain_name : "${var.subdomain}.${var.domain_name}"
  url_prefix        = var.ssl ? "https" : "http"
  url               = "${local.url_prefix}://${local.fqdn}"
  internal_app_port = 32543
  create_bucket     = var.bucket_name == ""
  network           = data.google_compute_network.default
  subnetwork        = data.google_compute_subnetwork.default
}

module "service_accounts" {
  source      = "../../modules/service_accounts"
  namespace   = var.namespace
  bucket_name = var.bucket_name
  depends_on  = [module.project_factory_project_services]
}

module "kms" {
  # KMS is currently only used to encrypt pubsub queue. Disable it if we dont use it.
  count               = var.use_internal_queue ? 0 : 1
  source              = "../../modules/kms"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection
}

locals {
  crypto_key = var.use_internal_queue ? null : module.kms.0.crypto_key
}

module "storage" {
  count     = local.create_bucket ? 1 : 0
  source    = "../../modules/storage"
  namespace = var.namespace
  labels    = var.labels

  create_queue    = !var.use_internal_queue
  bucket_location = "US"
  service_account = module.service_accounts.service_account
  crypto_key      = local.crypto_key

  deletion_protection = var.deletion_protection
  depends_on          = [module.project_factory_project_services]
}

module "app_lb" {
  source                = "../../modules/app_lb"
  namespace             = var.namespace
  ssl                   = var.ssl
  fqdn                  = local.fqdn
  network               = local.network
  group                 = data.google_container_cluster.default.name
  service_account       = module.service_accounts.service_account
  labels                = var.labels
  allowed_inbound_cidrs = var.allowed_inbound_cidrs

  depends_on = [module.project_factory_project_services]
}


locals {
  redis_certificate       = var.redis_cluster_name != "" ? data.google_redis_instance.default.server_ca_certs[0].cert : null
  redis_connection_string = var.redis_cluster_name != "" ? "redis://:${var.redis_env.password}@${var.redis_env.host}?tls=true&ttlInSeconds=604800&caCertPath=/etc/ssl/certs/server_ca.pem" : null
  bucket                  = local.create_bucket ? module.storage.0.bucket_name : var.bucket_name
  bucket_queue            = var.use_internal_queue ? "internal://" : "pubsub:/${module.storage.0.bucket_queue_name}"
  project_id              = module.project_factory_project_services.project_id
  secret_store_source     = "gcp-secretmanager://${local.project_id}?namespace=${var.namespace}"
}

module "gke_app" {
  source  = "wandb/wandb/kubernetes"
  version = "1.14.1"

  license = var.license

  host                       = local.url
  bucket                     = "gs://${local.bucket}"
  bucket_queue               = local.bucket_queue
  database_connection_string = var.database_env.connection_string
  redis_connection_string    = local.redis_connection_string
  redis_ca_cert              = local.redis_certificate

  oidc_client_id   = var.oidc_client_id
  oidc_issuer      = var.oidc_issuer
  oidc_auth_method = var.oidc_auth_method
  oidc_secret      = var.oidc_secret
  local_restore    = var.local_restore

  other_wandb_env = merge({
    "GORILLA_DISABLE_CODE_SAVING"          = var.disable_code_saving,
    "GORILLA_CUSTOMER_SECRET_STORE_SOURCE" = local.secret_store_source,
    "GORILLA_GLUE_LIST"                    = true
  }, var.other_wandb_env)

  wandb_image    = var.wandb_image
  wandb_version  = var.wandb_version
  wandb_replicas = 0

  resource_limits   = var.resource_limits
  resource_requests = var.resource_requests

  # If we dont wait, tf will start trying to deploy while the work group is
  # still spinning up
  depends_on = [
    module.storage,
  ]
}

locals {
  oidc_envs = var.oidc_issuer != "" ? {
    "OIDC_ISSUER"      = var.oidc_issuer
    "OIDC_CLIENT_ID"   = var.oidc_client_id
    "OIDC_AUTH_METHOD" = var.oidc_auth_method
    "OIDC_SECRET"      = var.oidc_secret
  } : {}
}

module "wandb" {
  source  = "wandb/wandb/helm"
  version = "1.2.0"

  spec = {
    values = {
      global = {
        host    = local.url
        license = var.license

        extraEnv = merge({
          "GORILLA_DISABLE_CODE_SAVING"          = var.disable_code_saving,
          "GORILLA_CUSTOMER_SECRET_STORE_SOURCE" = local.secret_store_source,
          "TAG_CUSTOMER_NS"                      = var.namespace
        }, var.other_wandb_env, local.oidc_envs)

        bucket = {
          provider = "gcs"
          name     = local.bucket
        }

        mysql = {
          name     = var.database_env.database_name
          user     = var.database_env.username
          password = var.database_env.password
          database = var.database_env.database_name
          host     = var.database_env.private_ip_address
          port     = 3306
        }

        redis = var.redis_cluster_name != "" ? {
          password = var.redis_env.password
          host     = var.redis_env.host
          port     = var.redis_env.port
          caCert   = local.redis_certificate
          params = {
            tls          = true
            ttlInSeconds = 604800
            caCertPath   = "/etc/ssl/certs/redis_ca.pem"
          }
        } : null
      }

      app = {
        extraEnvs = var.app_wandb_env
      }

      ingress = {
        nameOverride = var.namespace
        annotations = {
          "kubernetes.io/ingress.class"                 = "gce"
          "kubernetes.io/ingress.global-static-ip-name" = module.app_lb.address_operator_name
          "ingress.gcp.kubernetes.io/pre-shared-cert"   = module.app_lb.certificate
        }
      }

      redis = { install = false }
      mysql = { install = false }

      weave = {
        extraEnvs = var.weave_wandb_env
      }

      parquet = {
        extraEnvs = var.parquet_wandb_env
      }
    }
  }

  controller_image_tag   = "1.11.1"
  operator_chart_version = "1.1.2"

  # Added `depends_on` to ensure old infrastructure is provisioned first. This addresses a critical scheduling challenge
  # where the Datadog DaemonSet could fail to provision due to CPU constraints. Ensuring the old infrastructure has priority
  # mitigates the risk of "insufficient CPU" errors by facilitating controlled pod scheduling across nodes.
  # TODO: Remove `depends_on` for phase 3
  depends_on = [
    module.app_lb
  ]
}