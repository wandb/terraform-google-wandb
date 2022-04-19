module "bucket" {
  source    = "./bucket"
  namespace = var.namespace
  labels    = var.labels

  bucket_location = var.bucket_location
  service_account = var.service_account

  deletion_protection = var.deletion_protection
}

module "pubsub" {
  count = var.create_queue ? 1 : 0

  source    = "./pubsub"
  namespace = var.namespace
  labels    = var.labels

  bucket          = module.bucket.bucket_name
  service_account = var.service_account
  crypto_key      = var.crypto_key

  deletion_protection = var.deletion_protection
}