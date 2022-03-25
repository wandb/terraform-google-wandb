module "project_factory_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3"

  project_id = null

  activate_apis = [
    "iam.googleapis.com",               // Service accounts
    "logging.googleapis.com",           // Logging
    "sqladmin.googleapis.com",          // Database
    "networkmanagement.googleapis.com", // Networking
    "servicenetworking.googleapis.com", // Networking
    "redis.googleapis.com",             // Redis
    "pubsub.googleapis.com",            // File Storage
    "storage.googleapis.com",           // Cloud Storage
  ]
  disable_dependent_services  = false
  disable_services_on_destroy = false
}

locals {
  fqdn              = var.subdomain == null ? var.domain_name : "${var.subdomain}.${var.domain_name}"
  url_prefix        = var.ssl ? "https" : "http"
  url               = "${local.url_prefix}://${local.fqdn}"
  internal_app_port = 32543
}

module "service_accounts" {
  source    = "./modules/service_accounts"
  namespace = var.namespace

  depends_on = [module.project_factory_project_services]
}

module "file_storage" {
  source    = "./modules/file_storage"
  namespace = var.namespace
  labels    = var.labels

  create_queue    = !var.use_internal_queue
  bucket_location = "US"

  service_account = module.service_accounts.service_account

  deletion_protection = var.deletion_protection

  depends_on = [module.project_factory_project_services]
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace

  depends_on = [module.project_factory_project_services]
}

module "app_gke" {
  source    = "./modules/app_gke"
  namespace = var.namespace

  network         = module.networking.network
  subnetwork      = module.networking.subnetwork
  service_account = module.service_accounts.service_account

  depends_on = [module.project_factory_project_services]
}


module "app_lb" {
  source    = "./modules/app_lb"
  namespace = var.namespace

  ssl             = var.ssl
  fqdn            = local.fqdn
  network         = module.networking.network
  group           = module.app_gke.instance_group_url
  service_account = module.service_accounts.service_account

  depends_on = [module.project_factory_project_services]
}

module "database" {
  source    = "./modules/database"
  namespace = var.namespace

  network_connection  = module.networking.connection
  deletion_protection = var.deletion_protection

  depends_on = [module.project_factory_project_services]
}