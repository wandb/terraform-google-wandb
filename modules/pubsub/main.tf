terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.34.0"
    }
  }
}
locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "google_pubsub_topic" "filestream" {
  name         = "${var.namespace}-filestream"
  kms_key_name = var.crypto_key

  labels = var.labels
}

resource "google_pubsub_topic_iam_member" "filestream" {
  topic  = google_pubsub_topic.filestream.name
  role   = "roles/pubsub.admin"
  member = local.sa_member
}

resource "google_pubsub_subscription" "filestream-gorilla" {
  name  = "${var.namespace}-filestream-gorilla"
  topic = google_pubsub_topic.filestream.name

  message_retention_duration = "604800s" # 7 days.
  ack_deadline_seconds       = 30

  labels = var.labels
}

resource "google_pubsub_subscription_iam_member" "filestream-gorilla" {
  subscription = google_pubsub_subscription.filestream-gorilla.name
  role         = "roles/pubsub.admin"
  member       = local.sa_member
}

resource "google_pubsub_topic" "run_updates_v2" {
  name         = "${var.namespace}-run-updates-v2"
  kms_key_name = var.crypto_key

  labels = var.labels
}

resource "google_pubsub_topic_iam_member" "run_updates_v2" {
  topic  = google_pubsub_topic.run_updates_v2.name
  role   = "roles/pubsub.admin"
  member = local.sa_member
}

resource "google_pubsub_subscription" "flat_run_fields_updater_v2" {
  name  = "${var.namespace}-flat-run-fields-updater-v2"
  topic = google_pubsub_topic.run_updates_v2.name

  message_retention_duration = "604800s" # 7 days.
  ack_deadline_seconds       = 60

  labels = var.labels
}

resource "google_pubsub_subscription_iam_member" "flat_run_fields_updater_v2" {
  subscription = google_pubsub_subscription.flat_run_fields_updater_v2.name
  role         = "roles/pubsub.admin"
  member       = local.sa_member
}