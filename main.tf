module "app_gke" {
  source          = "./modules/app_gke"
  namespace       = var.namespace
  machine_type    = var.gke_machine_type
  network         = local.network
  subnetwork      = local.subnetwork
  service_account = module.service_accounts.service_account
  depends_on      = [module.project_factory_project_services]
}


module "app_lb" {
  count = var.internal_loadbalancer ? 1 : 0
  source               = "./modules/app_lb"
  depends_on = [module.project_factory_project_services, module.app_gke]

  allowed_inbound_cidr = var.allowed_inbound_cidr
  fqdn                 = local.fqdn
  group                = module.app_gke.instance_group_url
  labels               = var.labels
  namespace            = var.namespace
  network              = local.network
  service_account      = module.service_accounts.service_account
  ssl                  = var.ssl
}

module "database" {
  source              = "./modules/database"
  namespace           = var.namespace
  database_version    = var.database_version
  force_ssl           = var.force_ssl
  tier                = var.database_machine_type
  sort_buffer_size    = var.database_sort_buffer_size
  network_connection  = local.network_connection
  deletion_protection = var.deletion_protection
  labels              = var.labels
  depends_on          = [module.project_factory_project_services]
}

module "gke_app" {
  source  = "wandb/wandb/kubernetes"
  version = "1.6.0"

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
    "GORILLA_DISABLE_CODE_SAVING" = var.disable_code_saving
  }, var.other_wandb_env)

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

module "kms" {
  # KMS is currently only used to encrypt pubsub queue. Disable it if we dont use it.
  count               = var.use_internal_queue ? 0 : 1
  source              = "./modules/kms"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection
}

module "networking" {
  count = local.create_network ? 1 : 0

  source     = "./modules/networking"
  namespace  = var.namespace
  depends_on = [module.project_factory_project_services]
}


module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 13.0"
  project_id                  = null
  disable_dependent_services  = false
  disable_services_on_destroy = false
  activate_apis = [
    "cloudasset.googleapis.com",         // required for datadog monitoring
    "cloudkms.googleapis.com",          // KMS
    "compute.googleapis.com",           // required for datadog monitoring
    "iam.googleapis.com",               // Service accounts
    "logging.googleapis.com",           // Logging
    "networkmanagement.googleapis.com", // Networking
    "pubsub.googleapis.com",            // File Storage
    "redis.googleapis.com",             // Redis
    "servicenetworking.googleapis.com", // Networking
    "sqladmin.googleapis.com",          // Database
    "storage.googleapis.com"           // Cloud Storage
  ]
}


module "redis" {
  count          = var.create_redis ? 1 : 0
  labels         = var.labels
  memory_size_gb = 4
  namespace = var.namespace
  network        = local.network
  source         = "./modules/redis"
}

module "service_accounts" {
  source      = "./modules/service_accounts"
  namespace   = var.namespace
  bucket_name = var.bucket_name
  depends_on  = [module.project_factory_project_services]
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











