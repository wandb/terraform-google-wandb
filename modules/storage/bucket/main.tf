locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "file_storage" {
  length = 2
}
data "google_project" "default" {
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-${random_pet.file_storage.id}"
  location = var.bucket_location
  project  = var.project_id

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  labels = var.labels

  encryption {
    default_kms_key_name = var.crypto_key.id
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["*"]
    max_age_seconds = 3000
  }
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.file_storage.name
  member = local.sa_member
  role   = "roles/storage.objectAdmin"
}