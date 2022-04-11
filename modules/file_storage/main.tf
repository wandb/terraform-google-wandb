locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "file_storage" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-file-storage-${random_pet.file_storage.id}"
  location = var.bucket_location

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  labels = var.labels

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.file_storage.name
  member = local.sa_member
  role   = "roles/storage.objectAdmin"
}

resource "google_pubsub_topic" "file_storage" {
  name         = "${var.namespace}-file-storage"
  kms_key_name = var.crypto_key.id
}

resource "google_pubsub_topic_iam_member" "admin" {
  topic  = google_pubsub_topic.file_storage.name
  member = local.sa_member
  role   = "roles/pubsub.admin"
}

resource "google_pubsub_subscription" "file_storage" {
  name                 = "${var.namespace}-file-storage"
  topic                = google_pubsub_topic.file_storage.name
  ack_deadline_seconds = 30
}

resource "google_pubsub_subscription_iam_member" "admin" {
  subscription = google_pubsub_subscription.file_storage.name
  member       = local.sa_member
  role         = "roles/pubsub.admin"
}

# Enable notifications by giving the correct IAM permission to the unique
# service account.
data "google_storage_project_service_account" "default" {
}

# Google needs access to publish events from the bucket onto the queue.
resource "google_pubsub_topic_iam_member" "gcp_publisher" {
  topic  = google_pubsub_topic.file_storage.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${data.google_storage_project_service_account.default.email_address}"
}

resource "google_storage_notification" "file_storage" {
  bucket         = google_storage_bucket.file_storage.name
  topic          = google_pubsub_topic.file_storage.name
  payload_format = "JSON_API_V1"

  depends_on = [google_pubsub_topic_iam_member.gcp_publisher]
}
