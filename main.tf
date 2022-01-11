
module "file_storage" {
  source    = "./modules/file_storage"
  namespace = var.namespace

  create_queue    = !var.use_internal_queue
  bucket_location = "US"

  deletion_protection = var.deletion_protection
}