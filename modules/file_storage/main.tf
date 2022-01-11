locals {
  member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "suffix" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-file-storage-${random_pet.suffix.id}"
  location = var.bucket_location

  force_destroy = !var.deletion_protection

  cors {
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["ETag"]
    max_age_seconds = 3000
  }
}

