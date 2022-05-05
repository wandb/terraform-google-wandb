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
    "cloudkms.googleapis.com"           // KMS
  ]
}

locals {
  fqdn              = var.subdomain == null ? var.domain_name : "${var.subdomain}.${var.domain_name}"
  url_prefix        = var.ssl ? "https" : "http"
  url               = "${local.url_prefix}://${local.fqdn}"
  internal_app_port = 32543
  create_bucket     = var.bucket_name == ""
}

module "service_accounts" {
  source      = "./modules/service_accounts"
  namespace   = var.namespace
  bucket_name = var.bucket_name
  depends_on  = [module.project_factory_project_services]
}

module "kms" {
  # KMS is currently only used to encrypt pubsub queue. Disable it if we dont use it.
  count               = var.use_internal_queue ? 0 : 1
  source              = "./modules/kms"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection
}

locals {
  crypto_key = var.use_internal_queue ? null : module.kms.0.crypto_key
}

module "storage" {
  count     = local.create_bucket ? 1 : 0
  source    = "./modules/storage"
  namespace = var.namespace
  labels    = var.labels

  create_queue    = !var.use_internal_queue
  bucket_location = "US"
  service_account = module.service_accounts.service_account
  crypto_key      = local.crypto_key

  deletion_protection = var.deletion_protection
  depends_on          = [module.project_factory_project_services]
}

module "networking" {
  source     = "./modules/networking"
  namespace  = var.namespace
  depends_on = [module.project_factory_project_services]
}

module "app_gke" {
  source          = "./modules/app_gke"
  namespace       = var.namespace
  network         = module.networking.network
  subnetwork      = module.networking.subnetwork
  service_account = module.service_accounts.service_account
  depends_on      = [module.project_factory_project_services]
}


module "app_lb" {
  source          = "./modules/app_lb"
  namespace       = var.namespace
  ssl             = var.ssl
  fqdn            = local.fqdn
  network         = module.networking.network
  group           = module.app_gke.instance_group_url
  service_account = module.service_accounts.service_account
  depends_on      = [module.project_factory_project_services]
}

module "database" {
  source              = "./modules/database"
  namespace           = var.namespace
  database_version    = var.database_version
  network_connection  = module.networking.connection
  deletion_protection = var.deletion_protection
  depends_on          = [module.project_factory_project_services]
}

module "redis" {
  count          = var.create_redis ? 1 : 0
  source         = "./modules/redis"
  namespace      = var.namespace
  memory_size_gb = 4
  network        = module.networking.network
}

locals {
  redis_certificate       = var.create_redis ? module.redis.0.ca_cert : null
  redis_connection_string = var.create_redis ? "redis://:${module.redis.0.auth_string}@${module.redis.0.connection_string}?tls=true&ttlInSeconds=60&caCertPath=/etc/ssl/certs/server_ca.pem" : null
  bucket                  = local.create_bucket ? module.storage.0.bucket_name : var.bucket_name
  bucket_queue            = var.use_internal_queue ? "internal://" : "pubsub:/${module.storage.0.bucket_queue_name}"
}

module "gke_app" {
  source  = "wandb/wandb/kubernetes"
  version = "1.1.1"

  license = var.license

  host                       = local.url
  bucket                     = "gs://${local.bucket}"
  bucket_queue               = local.bucket_queue
  database_connection_string = "mysql://${module.database.connection_string}"
  redis_connection_string    = local.redis_connection_string
  redis_ca_cert              = local.redis_certificate

  oidc_client_id   = var.oidc_client_id
  oidc_issuer      = var.oidc_issuer
  oidc_auth_method = var.oidc_auth_method

  wandb_image   = var.wandb_image
  wandb_version = var.wandb_version

  # If we dont wait, tf will start trying to deploy while the work group is
  # still spinning up
  depends_on = [
    module.database,
    module.redis,
    module.storage,
    module.app_gke
  ]
}
