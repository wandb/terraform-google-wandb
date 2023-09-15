module "bucket" {
  source = "./bucket"

  bucket_location     = var.bucket_location
  deletion_protection = var.deletion_protection
  labels              = var.labels
  namespace           = var.namespace
  project_id          = var.project_id
  service_account     = var.service_account
}

module "pubsub" {
  source = "./pubsub"
  count  = var.create_queue ? 1 : 0

  bucket              = module.bucket.bucket_name
  crypto_key          = var.crypto_key
  deletion_protection = var.deletion_protection
  labels              = var.labels
  namespace           = var.namespace
  service_account     = var.service_account
}
