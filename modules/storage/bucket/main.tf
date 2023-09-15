locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "file_storage" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  force_destroy               = !var.deletion_protection
  labels                      = var.labels
  location                    = var.bucket_location
  name                        = "${var.namespace}-${random_pet.file_storage.id}"
  project                     = var.project_id
  uniform_bucket_level_access = true

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
