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
    "secretmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com" // required for secrets
  ]
}

locals {
  fqdn              = var.subdomain == null ? var.domain_name : "${var.subdomain}.${var.domain_name}"
  url_prefix        = var.ssl ? "https" : "http"
  url               = "${local.url_prefix}://${local.fqdn}"
  internal_app_port = 32543
  create_bucket     = var.bucket_name == ""
  create_network    = var.network == null
  bucket_location   = var.bucket_location == "" ? "US" : var.bucket_location
  database_region   = var.database_region == "" ? "us-central1" : var.database_region

  # Specifications for t-shirt sized deployments
  deployment_size = {
    small = {
      db            = "db-n1-highmem-2",
      node_count    = 2,
      node_instance = "n2-highmem-4"
      cache         = "Standard 6 GB"
    },
    medium = {
      db            = "db-n1-highmem-4",
      node_count    = 2,
      node_instance = "n2-highmem-4"
      cache         = "Standard 6 GB"
    },
    large = {
      db            = "db-n1-highmem-8",
      node_count    = 2,
      node_instance = "n2-highmem-8"
      cache         = "Standard 13 GB"
    },
    xlarge = {
      db            = "db-n1-highmem-16",
      node_count    = 3,
      node_instance = "n2-highmem-8"
      cache         = "Standard 13 GB"
    },
    xxlarge = {
      db            = "db-n1-highmem-32",
      node_count    = 3,
      node_instance = "n2-highmem-16"
      cache         = "Standard 26 GB"
    }
  }
}

module "service_accounts" {
  source      = "./modules/service_accounts"
  namespace   = var.namespace
  bucket_name = var.bucket_name
  depends_on  = [module.project_factory_project_services]
}

module "kms_default_bucket" {
  count                          = var.bucket_kms_key_id == "" ? 1 : 0
  source                         = "./modules/kms"
  namespace                      = var.namespace
  deletion_protection            = var.deletion_protection
  key_location                   = lower(local.bucket_location)
  bind_pubsub_service_to_kms_key = !var.use_internal_queue
}

module "kms_default_sql" {

  count                          = var.db_kms_key_id == "" ? 1 : 0
  source                         = "./modules/kms"
  namespace                      = var.namespace
  deletion_protection            = var.deletion_protection
  key_location                   = local.database_region
  bind_pubsub_service_to_kms_key = false
}

locals {
  bucket_crypto_key = length(module.kms_default_bucket) > 0 ? module.kms_default_bucket[0].crypto_key.id : var.bucket_kms_key_id
  sql_crypto_key    = length(module.kms_default_sql) > 0 ? module.kms_default_sql[0].crypto_key.id : var.db_kms_key_id
}

module "storage" {
  count               = local.create_bucket ? 1 : 0
  source              = "./modules/storage"
  namespace           = var.namespace
  labels              = var.labels
  create_queue        = !var.use_internal_queue
  bucket_location     = local.bucket_location
  service_account     = module.service_accounts.service_account
  crypto_key          = local.bucket_crypto_key
  deletion_protection = var.deletion_protection
  depends_on          = [module.project_factory_project_services, module.kms_default_bucket.google_kms_crypto_key_iam_binding]
}

module "networking" {
  count = local.create_network ? 1 : 0

  source     = "./modules/networking"
  namespace  = var.namespace
  depends_on = [module.project_factory_project_services]
}

locals {
  network_connection = try(module.networking.0.connection, { network = var.network })
  network            = try(module.networking.0.network, { self_link = var.network })
  subnetwork         = try(module.networking.0.subnetwork, { self_link = var.subnetwork })
}

module "app_gke" {
  source          = "./modules/app_gke"
  namespace       = var.namespace
  machine_type    = coalesce(try(local.deployment_size[var.size].node_instance, null), var.gke_machine_type)
  node_count      = coalesce(try(local.deployment_size[var.size].node_count, null), var.gke_node_count)
  network         = local.network
  subnetwork      = local.subnetwork
  service_account = module.service_accounts.service_account
  depends_on      = [module.project_factory_project_services]
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

  depends_on = [module.project_factory_project_services, module.app_gke]
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
  crypto_key          = local.sql_crypto_key
  region              = local.database_region
  depends_on          = [module.project_factory_project_services, module.kms_default_sql.google_kms_crypto_key_iam_binding]
}

module "redis" {
  count             = var.create_redis ? 1 : 0
  source            = "./modules/redis"
  namespace         = var.namespace
  memory_size_gb    = 4
  network           = local.network
  reserved_ip_range = var.redis_reserved_ip_range
  labels            = var.labels
  depends_on        = [module.project_factory_project_services]
  tier              = coalesce(try(local.deployment_size[var.size].cache, null), var.redis_tier)
}

locals {
  redis_certificate       = var.create_redis ? module.redis.0.ca_cert : null
  redis_connection_string = var.create_redis ? "redis://:${module.redis.0.auth_string}@${module.redis.0.connection_string}?tls=true&ttlInSeconds=604800&caCertPath=/etc/ssl/certs/server_ca.pem" : null
  bucket                  = local.create_bucket ? module.storage.0.bucket_name : var.bucket_name
  bucket_queue            = var.use_internal_queue ? "internal://" : "pubsub:/${module.storage.0.bucket_queue_name}"
  project_id              = module.project_factory_project_services.project_id
  secret_store_source     = "gcp-secretmanager://${local.project_id}?namespace=${var.namespace}"
}

module "gke_app" {
  source  = "wandb/wandb/kubernetes"
  version = "1.13.0"

  license = var.license

  host                       = local.url
  bucket                     = "gs://${local.bucket}"
  bucket_queue               = local.bucket_queue
  database_connection_string = module.database.connection_string
  redis_connection_string    = local.redis_connection_string
  redis_ca_cert              = local.redis_certificate

  oidc_client_id   = var.oidc_client_id
  oidc_issuer      = var.oidc_issuer
  oidc_auth_method = var.oidc_auth_method
  oidc_secret      = var.oidc_secret
  local_restore    = var.local_restore
  other_wandb_env = merge({
    "GORILLA_DISABLE_CODE_SAVING"          = var.disable_code_saving,
    "GORILLA_CUSTOMER_SECRET_STORE_SOURCE" = local.secret_store_source
  }, var.other_wandb_env)

  wandb_image   = var.wandb_image
  wandb_version = var.wandb_version

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
