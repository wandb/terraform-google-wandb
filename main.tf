module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 14.0"
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
  fqdn           = var.subdomain == null ? var.domain_name : "${var.subdomain}.${var.domain_name}"
  url_prefix     = var.ssl ? "https" : "http"
  url            = "${local.url_prefix}://${local.fqdn}"
  create_bucket  = var.bucket_name == ""
  create_network = var.network == null
  k8s_sa_map = {
    app         = "wandb-app"
    parquet     = "wandb-parquet"
    flat_runs   = "wandb-flat-run-fields-updater"
    weave       = "wandb-weave"
    weave_trace = "wandb-weave-trace"
  }
}

module "service_accounts" {
  source                   = "./modules/service_accounts"
  namespace                = var.namespace
  bucket_name              = var.bucket_name
  kms_gcs_sa_list          = values(local.k8s_sa_map)
  create_workload_identity = var.create_workload_identity
  stackdriver_sa_name      = var.stackdriver_sa_name
  enable_stackdriver       = var.enable_stackdriver
  depends_on               = [module.project_factory_project_services]
}

module "kms" {
  # KMS is currently only used to encrypt pubsub queue. Disable it if we dont use it.
  count               = var.use_internal_queue ? 0 : 1
  source              = "./modules/kms"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection
}

module "kms_default_bucket" {
  count                          = var.bucket_default_encryption ? 1 : 0
  source                         = "./modules/kms"
  namespace                      = var.namespace
  deletion_protection            = var.deletion_protection
  key_location                   = lower(var.bucket_location)
  bind_pubsub_service_to_kms_key = false
}

module "kms_default_sql" {
  count                          = var.sql_default_encryption ? 1 : 0
  source                         = "./modules/kms"
  namespace                      = var.namespace
  deletion_protection            = var.deletion_protection
  key_location                   = data.google_client_config.current.region
  bind_pubsub_service_to_kms_key = false
}
locals {
  default_bucket_key = length(module.kms_default_bucket) > 0 ? module.kms_default_bucket[0].crypto_key.id : var.bucket_kms_key_id
  default_sql_key    = length(module.kms_default_sql) > 0 ? module.kms_default_sql[0].crypto_key.id : var.db_kms_key_id
}

module "storage" {
  count     = local.create_bucket ? 1 : 0
  source    = "./modules/storage"
  namespace = var.namespace
  labels    = var.labels

  create_queue      = !var.use_internal_queue
  bucket_location   = var.bucket_location
  service_account   = module.service_accounts.service_account
  bucket_crypto_key = local.default_bucket_key
  crypto_key        = var.use_internal_queue ? null : module.kms[0].crypto_key

  deletion_protection = var.deletion_protection
  depends_on          = [module.project_factory_project_services, module.kms_default_bucket]
}

module "networking" {
  count = local.create_network ? 1 : 0

  source     = "./modules/networking"
  namespace  = var.namespace
  depends_on = [module.project_factory_project_services]
}

locals {
  network_connection = try(module.networking[0].connection, { network = var.network })
  network            = try(module.networking[0].network, { self_link = var.network })
  subnetwork         = try(module.networking[0].subnetwork, { self_link = var.subnetwork })
}

module "app_gke" {
  source                   = "./modules/app_gke"
  namespace                = var.namespace
  machine_type             = coalesce(try(local.deployment_size[var.size].node_instance, null), var.gke_machine_type)
  node_count               = coalesce(try(local.deployment_size[var.size].node_count, null), var.gke_node_count)
  network                  = local.network
  subnetwork               = local.subnetwork
  service_account          = module.service_accounts.service_account
  create_workload_identity = var.create_workload_identity
  depends_on               = [module.project_factory_project_services]
}

module "app_lb" {
  source                = "./modules/app_lb"
  namespace             = var.namespace
  ssl                   = var.ssl
  fqdn                  = local.fqdn
  network               = local.network
  group                 = module.app_gke.instance_group_url
  service_account       = module.service_accounts.service_account
  labels                = var.labels
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
  depends_on            = [module.project_factory_project_services, module.app_gke]
}

module "database" {
  source              = "./modules/database"
  namespace           = var.namespace
  database_version    = var.database_version
  force_ssl           = var.force_ssl
  tier                = coalesce(try(local.deployment_size[var.size].db, null), var.database_machine_type)
  sort_buffer_size    = var.database_sort_buffer_size
  network_connection  = local.network_connection
  deletion_protection = var.deletion_protection
  labels              = var.labels
  crypto_key          = local.default_sql_key
  depends_on          = [module.project_factory_project_services, module.kms_default_sql]
}

module "redis" {
  count     = var.create_redis ? 1 : 0
  source    = "./modules/redis"
  namespace = var.namespace
  ### here we set the default to 6gb, which is = setting for "small" standard size
  memory_size_gb    = coalesce(try(local.deployment_size[var.size].cache, 6))
  network           = local.network
  reserved_ip_range = var.redis_reserved_ip_range
  tier              = var.redis_tier
  labels            = var.labels
  crypto_key        = local.default_sql_key
  depends_on        = [module.project_factory_project_services, module.kms_default_sql]
}

locals {
  redis_certificate       = var.create_redis ? module.redis[0].ca_cert : null
  redis_connection_string = var.create_redis ? "redis://:${module.redis[0].auth_string}@${module.redis[0].connection_string}?tls=true&ttlInSeconds=604800&caCertPath=/etc/ssl/certs/server_ca.pem" : null
  bucket                  = local.create_bucket ? module.storage[0].bucket_name : var.bucket_name
  bucket_queue            = var.use_internal_queue ? "internal://" : "pubsub:/${module.storage[0].bucket_queue_name}"
  project_id              = module.project_factory_project_services.project_id
  secret_store_source     = "gcp-secretmanager://${local.project_id}?namespace=${var.namespace}"
}

resource "google_compute_address" "default" {
  count        = var.create_private_link ? 1 : 0
  name         = "${var.namespace}-ip-address"
  subnetwork   = local.subnetwork.name
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}

module "gke_app" {
  source  = "wandb/wandb/kubernetes"
  version = "1.14.1"

  license = var.license

  host                       = local.url
  bucket                     = "gs://${local.bucket}"
  bucket_queue               = local.bucket_queue
  database_connection_string = module.database.connection_string
  redis_connection_string    = local.redis_connection_string
  redis_ca_cert              = local.redis_certificate
  oidc_client_id             = var.oidc_client_id
  oidc_issuer                = var.oidc_issuer
  oidc_auth_method           = var.oidc_auth_method
  oidc_secret                = var.oidc_secret
  local_restore              = var.local_restore

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
    module.database,
    module.redis,
    module.storage,
    module.app_gke
  ]
}

locals {
  oidc_envs = var.oidc_issuer != "" ? {
    "OIDC_ISSUER"      = var.oidc_issuer
    "OIDC_CLIENT_ID"   = var.oidc_client_id
    "OIDC_AUTH_METHOD" = var.oidc_auth_method
    "OIDC_SECRET"      = var.oidc_secret
  } : {}
  internal_lb_name = "${var.namespace}-internal"
}

locals {
  workload_hash = var.create_workload_identity ? substr(sha256("yes"), 0, 50) : null
}

data "google_client_config" "current" {}

module "wandb" {
  source  = "wandb/wandb/helm"
  version = "1.2.0"

  spec = {
    values = {
      global = {
        pod           = { labels = { workload_hash : local.workload_hash } }
        host          = local.url
        license       = var.license
        cloudProvider = "gcp"
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
          name     = module.database.database_name
          user     = module.database.username
          password = module.database.password
          database = module.database.database_name
          host     = module.database.private_ip_address
          port     = 3306
        }

        redis = var.create_redis ? {
          password = module.redis[0].auth_string
          host     = module.redis[0].host
          port     = module.redis[0].port
          caCert   = module.redis[0].ca_cert
          params = {
            tls          = true
            ttlInSeconds = 604800
            caCertPath   = "/etc/ssl/certs/redis_ca.pem"
          }
          } : {
          password = ""
          host     = ""
          port     = 0
          caCert   = ""
          params = {
            tls          = false
            ttlInSeconds = 0
            caCertPath   = ""
          }
        }
      }

      app = {
        extraEnvs = var.app_wandb_env
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.app
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = ""
          annotations = {}
        }
      }

      ingress = {
        create       = var.public_access # external ingress for public connection
        nameOverride = var.namespace
        annotations = {
          "kubernetes.io/ingress.class"                 = "gce"
          "kubernetes.io/ingress.global-static-ip-name" = module.app_lb.address_operator_name
          "ingress.gcp.kubernetes.io/pre-shared-cert"   = module.app_lb.certificate
        }
        ## In order to support secondary ingress required min version 0.13.0 of operator-wandb chart
        secondary = {
          create       = var.create_private_link # internal ingress for private link connections
          nameOverride = local.internal_lb_name
          annotations = {
            "kubernetes.io/ingress.class"                   = "gce-internal"
            "kubernetes.io/ingress.regional-static-ip-name" = var.create_private_link ? google_compute_address.default[0].name : null
          }
        }
      }

      # To support otel rds and redis metrics need operator-wandb chart minimum version 0.13.8 ( stackdriver subchart)
      stackdriver = var.enable_stackdriver ? {
        install = true
        stackdriver = {
          projectId          = data.google_client_config.current.project
          serviceAccountName = var.stackdriver_sa_name
        }
        serviceAccount = { annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.stackdriver_role } }
        } : {
        install        = false
        stackdriver    = {}
        serviceAccount = {}
      }

      otel = {
        daemonset = var.enable_stackdriver ? {
          config = {
            receivers = {
              prometheus = {
                config = {
                  scrape_configs = [
                    { job_name     = "stackdriver"
                      scheme       = "http"
                      metrics_path = "/metrics"
                      dns_sd_configs = [
                        { names = ["wandb-stackdriver"]
                          type  = "A"
                          port  = 9255
                        }
                      ]
                    }
                  ]
                }
              }
            }
            service = {
              pipelines = {
                metrics = {
                  receivers = ["hostmetrics", "k8s_cluster", "kubeletstats", "prometheus"]
                }
              }
            }
          }
          } : { config = {
            receivers = {}
            service   = {}
          }
        }
      }

      redis = { install = !var.create_redis }
      mysql = { install = false }

      weave = {
        extraEnvs = var.weave_wandb_env
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.weave
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }

      weave-trace = {
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.weave_trace
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }

      parquet = {
        extraEnvs = var.parquet_wandb_env
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.parquet
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }

      flat-runs-fields-updater = {
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.flat_runs
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }
    }
  }

  controller_image_tag   = "1.12.0"
  operator_chart_version = "1.2.4"

  # Added `depends_on` to ensure old infrastructure is provisioned first. This addresses a critical scheduling challenge
  # where the Datadog DaemonSet could fail to provision due to CPU constraints. Ensuring the old infrastructure has priority
  # mitigates the risk of "insufficient CPU" errors by facilitating controlled pod scheduling across nodes.
  # TODO: Remove `depends_on` for phase 3
  depends_on = [
    module.gke_app
  ]
}

# proxy-only subnet used by internal load balancer
resource "google_compute_subnetwork" "proxy" {
  count         = var.create_private_link ? 1 : 0
  name          = "${var.namespace}-proxy-subnet"
  ip_cidr_range = var.ilb_proxynetwork_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = local.network.id
  timeouts {
    delete = "2m"
  }
}

## This ensures that the private link resource does not fail during the provisioning process.
module "sleep" {
  count   = var.create_private_link ? 1 : 0
  source  = "matti/resource/shell"
  version = "1.5.0"

  environment = {
    TIME = timestamp()
  }
  command              = "sleep 400; date +%s"
  command_when_destroy = "sleep 400"
  trigger              = timestamp()
  working_dir          = "/tmp"

  depends = [
    module.wandb
  ]
}

data "google_compute_forwarding_rules" "all" {
  depends_on = [module.sleep.stdout]
}

locals {
  regex_pattern       = local.internal_lb_name
  filtered_rule_names = [for rule in data.google_compute_forwarding_rules.all.rules : rule.name if can(regex(local.regex_pattern, rule.name))]
  forwarding_rule     = join(", ", local.filtered_rule_names)
}

## In order to support private link required min version 0.13.0 of operator-wandb chart
module "private_link" {
  count                 = var.create_private_link ? 1 : 0
  source                = "./modules/private_link"
  namespace             = var.namespace
  forwarding_rule       = local.forwarding_rule
  network               = local.network
  subnetwork            = local.subnetwork
  allowed_project_names = var.allowed_project_names
  psc_subnetwork        = var.psc_subnetwork_cidr
  proxynetwork_cidr     = var.ilb_proxynetwork_cidr
  depends_on            = [google_compute_subnetwork.proxy, data.google_compute_forwarding_rules.all]
}
