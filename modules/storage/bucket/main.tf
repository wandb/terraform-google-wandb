locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "file_storage" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-${random_pet.file_storage.id}"
  location = var.bucket_location

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  labels = var.labels

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
