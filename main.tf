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
  create_network = var.network == null
  k8s_sa_map = {
    app                    = "wandb-app"
    console                = "wandb-console"
    executor               = "wandb-executor"
    parquet                = "wandb-parquet"
    flat_runs              = "wandb-flat-run-fields-updater"
    filestream             = "wandb-filestream"
    weave                  = "wandb-weave"
    weave_trace            = "wandb-weave-trace"
    settings_migration_job = "wandb-settings-migration-job"
    wandb_api              = "wandb-api"
    wandb_glue             = "wandb-glue"
  }
  gke_machine_type      = coalesce(var.gke_machine_type, local.deployment_size[var.size].node_instance)
  max_node_count        = coalesce(var.gke_max_node_count, local.deployment_size[var.size].max_node_count)
  min_node_count        = coalesce(var.gke_min_node_count, local.deployment_size[var.size].min_node_count)
  database_machine_type = coalesce(var.database_machine_type, local.deployment_size[var.size].db)
  redis_memory_size_gb  = coalesce(var.redis_memory_size_gb, local.deployment_size[var.size].cache)
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
  skip_bucket_admin_role   = var.skip_bucket_admin_role
}

locals {
  app_service_account = (var.create_workload_identity) ? module.service_accounts.sa_account_role : module.service_accounts.service_account.email
}

module "kms" {
  # KMS is currently only used to encrypt pubsub queue. Disable it if we dont use it.
  count               = var.use_internal_queue ? 0 : 1
  source              = "./modules/kms"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection
}

module "kms_default_bucket" {
  count                            = var.bucket_default_encryption ? 1 : 0
  source                           = "./modules/kms"
  namespace                        = var.namespace
  deletion_protection              = var.deletion_protection
  key_location                     = lower(var.bucket_location)
  bind_pubsub_service_to_kms_key   = false
  bind_bigtable_service_to_kms_key = false
}

module "kms_default_sql" {
  count                            = var.sql_default_encryption ? 1 : 0
  source                           = "./modules/kms"
  namespace                        = var.namespace
  deletion_protection              = var.deletion_protection
  key_location                     = data.google_client_config.current.region
  bind_pubsub_service_to_kms_key   = var.create_pubsub
  bind_bigtable_service_to_kms_key = var.create_bigtable
}
locals {
  default_bucket_key = length(module.kms_default_bucket) > 0 ? module.kms_default_bucket[0].crypto_key.id : var.bucket_kms_key_id
  default_sql_key    = length(module.kms_default_sql) > 0 ? module.kms_default_sql[0].crypto_key.id : var.db_kms_key_id
}

module "storage" {
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
  count                    = local.create_network ? 1 : 0
  source                   = "./modules/networking"
  namespace                = var.namespace
  labels                   = var.labels
  google_api_psc_ipaddress = var.google_api_psc_ipaddress
  google_api_dns_overrides = var.google_api_dns_overrides
  depends_on               = [module.project_factory_project_services]
}

locals {
  network_connection = try(module.networking[0].connection, { network = var.network })
  network            = try(module.networking[0].network, { self_link = var.network })
  subnetwork         = try(module.networking[0].subnetwork, { self_link = var.subnetwork })
}

module "app_gke" {
  source                     = "./modules/app_gke"
  namespace                  = var.namespace
  machine_type               = local.gke_machine_type
  network                    = local.network
  subnetwork                 = local.subnetwork
  service_account            = module.service_accounts.service_account
  enable_gcs_fuse_csi_driver = var.enable_gcs_fuse_csi_driver
  create_workload_identity   = var.create_workload_identity
  deletion_protection        = var.deletion_protection
  depends_on                 = [module.project_factory_project_services]
  max_node_count             = local.max_node_count
  min_node_count             = local.min_node_count
  disk_size_gb               = var.gke_node_disk_size_gb
  labels                     = merge(var.labels, { cache_size = var.cache_size }, var.gke_cluster_labels)
  enable_private_gke_nodes   = var.enable_private_gke_nodes
}

module "cloud_nat" {
  count     = var.enable_private_gke_nodes || var.create_private_link ? 1 : 0
  source    = "./modules/cloud_nat"
  network   = local.network
  namespace = var.namespace
  vpc_nat   = var.enable_private_gke_nodes
  proxy_nat = var.create_private_link

  labels = var.labels
}

locals {
  allowed_inbound_cidrs = var.create_private_link && var.allowed_inbound_cidrs[0] != "*" ? concat(var.allowed_inbound_cidrs, ["${module.cloud_nat[0].cloudnat_lb_proxy_ip}/32"]) : var.allowed_inbound_cidrs
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
  allowed_inbound_cidrs = local.allowed_inbound_cidrs
  depends_on            = [module.project_factory_project_services, module.app_gke]
}

module "database" {
  source              = "./modules/database"
  namespace           = var.namespace
  database_version    = var.database_version
  force_ssl           = var.force_ssl
  tier                = local.database_machine_type
  edition             = var.database_edition
  data_cache_enabled  = var.database_data_cache_enabled
  database_flags      = var.database_flags
  sort_buffer_size    = var.database_sort_buffer_size
  network_connection  = local.network_connection
  deletion_protection = var.deletion_protection
  labels              = var.labels
  crypto_key          = local.default_sql_key
  depends_on          = [module.project_factory_project_services, module.kms_default_sql]
}

module "bigtable" {
  source = "./modules/bigtable"
  count  = var.create_bigtable ? 1 : 0

  namespace             = var.namespace
  deletion_protection   = var.deletion_protection
  service_account_email = local.app_service_account
  crypto_key            = local.default_sql_key
  storage_type          = var.bigtable_storage_type
  cpu_target            = var.bigtable_cpu_target
  min_nodes             = var.bigtable_min_nodes
  max_nodes             = var.bigtable_max_nodes

  labels = var.labels
}

module "pubsub" {
  source = "./modules/pubsub"
  count  = var.create_pubsub ? 1 : 0

  namespace             = var.namespace
  deletion_protection   = var.deletion_protection
  service_account_email = local.app_service_account
  crypto_key            = local.default_sql_key

  labels = var.labels
}

module "redis" {
  count     = var.create_redis ? 1 : 0
  source    = "./modules/redis"
  namespace = var.namespace
  ### here we set the default to 6gb, which is = setting for "small" standard size
  memory_size_gb    = local.redis_memory_size_gb
  network           = local.network
  reserved_ip_range = var.redis_reserved_ip_range
  tier              = var.redis_tier
  labels            = var.labels
  crypto_key        = local.default_sql_key
  depends_on        = [module.project_factory_project_services, module.kms_default_sql]
}

module "clickhouse" {
  count     = var.clickhouse_private_endpoint_service_name != "" ? 1 : 0
  source    = "./modules/clickhouse"
  network   = local.network.id
  namespace = var.namespace

  clickhouse_reserved_ip_range             = var.clickhouse_subnetwork_cidr
  clickhouse_private_endpoint_service_name = var.clickhouse_private_endpoint_service_name
  clickhouse_region                        = var.clickhouse_region
  clickhouse_org_id                        = var.clickhouse_org_id
  clickhouse_token_key                     = var.clickhouse_token_key
  clickhouse_secret_key                    = var.clickhouse_secret_key
  providers = {
    clickhouse = clickhouse
  }

  labels = var.labels
}

locals {
  redis_certificate       = var.create_redis ? module.redis[0].ca_cert : null
  redis_connection_string = var.create_redis ? "redis://:${module.redis[0].auth_string}@${module.redis[0].connection_string}?tls=true&ttlInSeconds=604800&caCertPath=/etc/ssl/certs/server_ca.pem" : null
  bucket                  = var.bucket_name != "" ? var.bucket_name : module.storage.bucket_name
  bucket_queue            = var.use_internal_queue ? "internal://" : "pubsub:/${module.storage.bucket_queue_name}"
  bucket_path             = var.bucket_path
  project_id              = module.project_factory_project_services.project_id
  secret_store_source     = "gcp-secretmanager://${local.project_id}?namespace=${var.namespace}"
}

resource "google_compute_address" "default" {
  count        = var.create_private_link ? 1 : 0
  name         = "${var.namespace}-ip-address"
  subnetwork   = local.subnetwork.name
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"

  labels = var.labels
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
}

locals {
  workload_hash = var.create_workload_identity ? substr(sha256("yes"), 0, 50) : null
}

data "google_client_config" "current" {}

locals {
  issuer_url = format(
    "https://container.googleapis.com/v1/projects/%s/locations/%s/clusters/%s",
    local.project_id,
    module.app_gke.location,
    "${var.namespace}-cluster"
  )
}

locals {
  ctrlplane_redis_host = "redis.redis.svc.cluster.local"
  ctrlplane_redis_port = "26379"
  ctrlplane_redis_params = {
    master = "gorilla"
  }

  spec = {
    values = {
      global = {
        size          = var.size
        pod           = { labels = { workload_hash : local.workload_hash } }
        host          = local.url
        license       = var.license
        cloudProvider = "gcp"
        extraEnv = merge({
          "GORILLA_DISABLE_CODE_SAVING"          = var.disable_code_saving,
          "GORILLA_CUSTOMER_SECRET_STORE_SOURCE" = local.secret_store_source,
          "TAG_CUSTOMER_NS"                      = var.namespace
        }, var.other_wandb_env, local.oidc_envs)

        bigtable = {
          project  = local.project_id
          instance = var.create_bigtable ? module.bigtable[0].bigtable_instance_id : ""
        }

        pubSub = {
          enabled              = var.create_pubsub
          project              = local.project_id
          filestreamTopic      = var.create_pubsub ? module.pubsub[0].filestream_topic_name : ""
          runUpdateShadowTopic = var.create_pubsub ? module.pubsub[0].run_updates_shadow_topic_name : ""
        }

        bucket = var.bucket_name != "" ? {
          provider = "gcs"
          name     = var.bucket_name
          path     = var.bucket_path
        } : {}

        defaultBucket = {
          provider = "gcs"
          name     = module.storage.bucket_name
          path     = var.bucket_path
        }

        mysql = {
          name     = module.database.database_name
          user     = module.database.username
          password = module.database.password
          database = module.database.database_name
          host     = module.database.private_ip_address
          port     = 3306
        }

        redis = var.use_ctrlplane_redis ? {
          host     = local.ctrlplane_redis_host
          password = ""
          port     = local.ctrlplane_redis_port
          caCert   = ""
          params   = local.ctrlplane_redis_params
          external = true
          } : var.use_external_redis ? {
          host     = var.external_redis_host
          password = ""
          port     = var.external_redis_port
          caCert   = ""
          external = true
          params   = var.external_redis_params
          } : var.create_redis ? {
          host     = module.redis[0].host
          password = module.redis[0].auth_string
          port     = module.redis[0].port
          caCert   = module.redis[0].ca_cert
          external = false
          params = {
            master = ""
          }
          } : {
          host     = ""
          password = ""
          port     = "6379"
          caCert   = ""
          external = false
          params = {
            master = ""
          }
        }

        gcpSecurityPolicy = module.app_lb.lb_security_policy_name

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
        internalJWTMap = [
          {
            subject = "system:serviceaccount:default:${local.k8s_sa_map.weave_trace}"
            issuer  = local.issuer_url
          }
        ]
      }

      console = {
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.console
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = ""
          annotations = {}
        }
        extraEnv = {
          "BUCKET_ACCESS_IDENTITY" = var.create_workload_identity ? module.service_accounts.sa_account_role : module.service_accounts.service_account.email
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
      }

      # To support otel rds and redis metrics need operator-wandb chart minimum version 0.13.8 ( stackdriver subchart)
      stackdriver = var.enable_stackdriver ? {
        install = true
        stackdriver = {
          projectId          = data.google_client_config.current.project
          serviceAccountName = var.stackdriver_sa_name
        }
        serviceAccount = {
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.stackdriver_role }
        }
        } : {
        install        = false
        stackdriver    = {}
        serviceAccount = {}
      }

      redis = { install = false }
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

      executor = {
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.executor
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }

      settingsMigrationJob = {
        serviceAccount = var.create_workload_identity ? {
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          name        = local.k8s_sa_map.settings_migration_job
          } : {
          name        = null
          annotations = {}
        }
      }

      api = {
        serviceAccount = var.create_workload_identity ? {
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          name        = local.k8s_sa_map.wandb_api
          } : {
          name        = null
          annotations = {}
        }
      }

      glue = {
        serviceAccount = var.create_workload_identity ? {
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          name        = local.k8s_sa_map.wandb_glue
          } : {
          name        = null
          annotations = {}
        }
      }

      flat-run-fields-updater = {
        pubSub = {
          subscription = var.create_pubsub ? module.pubsub[0].flat_run_fields_updater_subscription_name : ""
        }
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.flat_runs
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }

      filestream = {
        pubSub = {
          subscription = var.create_pubsub ? module.pubsub[0].filestream_gorilla_subscription_name : ""
        }
        serviceAccount = var.create_workload_identity ? {
          name        = local.k8s_sa_map.filestream
          annotations = { "iam.gke.io/gcp-service-account" = module.service_accounts.sa_account_role }
          } : {
          name        = null
          annotations = {}
        }
      }
    }
  }
}

module "wandb" {
  source  = "wandb/wandb/helm"
  version = "3.0.0"

  spec = local.spec

  controller_image_tag   = var.controller_image_tag
  operator_chart_version = var.operator_chart_version
  enable_helm_operator   = var.enable_helm_operator
  enable_helm_wandb      = var.enable_helm_wandb

  # Added `depends_on` to ensure old infrastructure is provisioned first. This addresses a critical scheduling challenge
  # where the Datadog DaemonSet could fail to provision due to CPU constraints. Ensuring the old infrastructure has priority
  # mitigates the risk of "insufficient CPU" errors by facilitating controlled pod scheduling across nodes.
  # TODO: Remove `depends_on` for phase 3
  depends_on = [
    module.gke_app
  ]
}

## In order to support private link required min version 0.13.0 of
## operator-wandb chart
module "private_link" {
  count                 = var.create_private_link ? 1 : 0
  source                = "./modules/private_link"
  namespace             = var.namespace
  network               = local.network
  subnetwork            = local.subnetwork
  allowed_project_names = var.allowed_project_names
  psc_subnetwork        = var.psc_subnetwork_cidr
  proxynetwork_cidr     = var.ilb_proxynetwork_cidr
  fqdn                  = local.fqdn

  labels = var.labels

  depends_on = [module.wandb]
}

moved {
  from = module.storage[0]
  to   = module.storage
}

