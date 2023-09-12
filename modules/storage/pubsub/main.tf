locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "google_pubsub_topic" "file_storage" {
  name         = "${var.namespace}-file-storage"
  project      = var.project_id
  kms_key_name = var.crypto_key.id
    labels = merge(
    var.labels,
    var.tags
  )
}

resource "google_pubsub_topic_iam_member" "admin" {
  topic   = google_pubsub_topic.file_storage.name
  project = var.project_id
  member  = local.sa_member
  role    = "roles/pubsub.admin"
}

resource "google_pubsub_subscription" "file_storage" {
  name                 = "${var.namespace}-file-storage"
  project              = var.project_id
  topic                = google_pubsub_topic.file_storage.name
  labels               = var.labels
  ack_deadline_seconds = 30
}

resource "google_pubsub_subscription_iam_member" "admin" {
  subscription = google_pubsub_subscription.file_storage.name
  project      = var.project_id
  member       = local.sa_member
  role         = "roles/pubsub.admin"
}

# Enable notifications by giving the correct IAM permission to the unique
# service account.
data "google_storage_project_service_account" "default" {
}

# Google needs access to publish events from the bucket onto the queue.
resource "google_pubsub_topic_iam_member" "gcp_publisher" {
  topic   = google_pubsub_topic.file_storage.id
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.default.email_address}"
}

resource "google_storage_notification" "file_storage" {
  bucket         = var.bucket
  topic          = google_pubsub_topic.file_storage.id
  payload_format = "JSON_API_V1"

  depends_on = [google_pubsub_topic_iam_member.gcp_publisher]
}
