module "project_factory_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0"


  disable_dependent_services  = false
  disable_services_on_destroy = false
  # TODO: the use of labels here doesn't seem to be supported
  # by this version of the module, despite the docs
  # https://registry.terraform.io/modules/terraform-google-modules/project-factory/google/13.0.0?tab=inputs
  #labels                      = var.labels
  project_id                  = null

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
    "cloudasset.googleapis.com"         // required for datadog monitoring
  ]
}

module "kms" {
  # KMS is currently only used to encrypt pubsub queue. Disable it if we dont use it.
  count               = var.use_internal_queue ? 0 : 1
  deletion_protection = var.deletion_protection
  labels              = var.labels
  namespace           = var.namespace
  source              = "./modules/kms"
}

module "service_accounts" {
  source     = "./modules/service_accounts"
  depends_on = [module.project_factory_project_services]

  bucket_name = var.bucket_name
  namespace   = var.namespace
}
module "storage" {
  source     = "./modules/storage"
  depends_on = [module.project_factory_project_services]
  count      = local.create_bucket ? 1 : 0

  bucket_location     = "US"
  create_queue        = !var.use_internal_queue
  crypto_key          = local.crypto_key
  deletion_protection = var.deletion_protection
  labels              = var.labels
  namespace           = var.namespace
  service_account     = module.service_accounts.service_account
}

module "networking" {
  depends_on = [module.project_factory_project_services]
  count      = local.create_network ? 1 : 0

  labels    = var.labels
  namespace = var.namespace
  source    = "./modules/networking"
}



module "app_gke" {
  source     = "./modules/app_gke"
  depends_on = [module.project_factory_project_services]

  labels          = var.labels
  machine_type    = var.gke_machine_type
  namespace       = var.namespace
  network         = local.network
  service_account = module.service_accounts.service_account
  subnetwork      = local.subnetwork
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
  tier                = var.database_machine_type
  sort_buffer_size    = var.database_sort_buffer_size
  network_connection  = local.network_connection
  deletion_protection = var.deletion_protection
  labels              = var.labels
  depends_on          = [module.project_factory_project_services]
}

module "redis" {
  count          = var.create_redis ? 1 : 0
  source         = "./modules/redis"
  namespace      = var.namespace
  memory_size_gb = 4
  network        = local.network
  labels         = var.labels
}


module "gke_app" {
  source  = "wandb/wandb/kubernetes"
  version = "1.12.0"

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
    "GORILLA_DISABLE_CODE_SAVING" = var.disable_code_saving
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
