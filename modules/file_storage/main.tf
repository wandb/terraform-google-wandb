locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "suffix" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-file-storage-${random_pet.suffix.id}"
  location = var.bucket_location

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  labels = var.labels

  cors {
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.file_storage.name
  member = local.sa_member
  role   = "roles/storage.admin"
}

resource "google_pubsub_topic" "file_storage" {
  name = "${var.namespace}-file-storage"
}

resource "google_pubsub_topic_iam_member" "file_storage_editor" {
  topic  = google_pubsub_topic.file_storage.name
  member = local.sa_member
  role   = "roles/editor"
}

resource "google_pubsub_subscription" "file_storage" {
  name                 = "${var.namespace}-file-storage"
  topic                = google_pubsub_topic.file_storage.name
  ack_deadline_seconds = 30
}

# Enable notifications by giving the correct IAM permission to the unique
# service account.
data "google_storage_project_service_account" "service" {
}

# For some reason we need to give the GCS Service agent access?
# TODO: figure out why? It would be nice if this could be all isolated to one account.
resource "google_pubsub_topic_iam_binding" "gcp_publisher" {
  topic   = google_pubsub_topic.file_storage.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.service.email_address}"]
}

resource "google_storage_notification" "file_storage" {
  bucket         = google_storage_bucket.file_storage.name
  topic          = google_pubsub_topic.file_storage.name
  payload_format = "JSON_API_V1"

  depends_on = [google_pubsub_topic_iam_binding.gcp_publisher]
}
