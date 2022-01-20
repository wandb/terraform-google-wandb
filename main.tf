
module "service_accounts" {
  source    = "./modules/service_accounts"
  namespace = var.namespace
}

module "file_storage" {
  source    = "./modules/file_storage"
  namespace = var.namespace

  create_queue    = !var.use_internal_queue
  bucket_location = "US"

  service_account = module.service_accounts.service_account

  deletion_protection = var.deletion_protection
}

module "database" {
  source    = "./modules/database"
  namespace = var.namespace

  deletion_protection = var.deletion_protection
}