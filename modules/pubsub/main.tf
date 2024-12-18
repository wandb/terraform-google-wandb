locals {
  sa_member = "serviceAccount:${var.service_account_email}"
}

resource "google_pubsub_topic" "filestream" {
  name         = "${var.namespace}-filestream"
  kms_key_name = var.crypto_key

  labels = var.labels
}

# TODO(dpanzella): Uncomment if dead letter is needed.
# resource "google_pubsub_topic" "filestream_dead_letter" {
#   count = var.enable_filestream ? 1 : 0
#   name         = "${var.namespace}-filestream-dead-letter"
#   kms_key_name = var.crypto_key
#
#   labels = var.labels
# }

resource "google_pubsub_topic_iam_member" "filestream" {
  topic  = google_pubsub_topic.filestream.name
  role   = "roles/pubsub.admin"
  member = local.sa_member
}

resource "google_pubsub_subscription" "filestream-gorilla" {
  name  = "${var.namespace}-filestream-gorilla"
  topic = google_pubsub_topic.filestream.name

  # TODO(dpanzella): Uncomment if dead letter is needed.
  # dead_letter_policy {
  #   dead_letter_topic     = google_pubsub_topic.filestream_dead_letter.name
  #   max_delivery_attempts = 5
  # }

  message_retention_duration = "604800s" # 7 days.
  ack_deadline_seconds       = 30

  labels = var.labels
}

resource "google_pubsub_subscription_iam_member" "filestream-gorilla" {
  subscription = google_pubsub_subscription.filestream-gorilla.name
  role         = "roles/pubsub.admin"
  member       = local.sa_member
}

resource "google_pubsub_topic" "run_updates_shadow" {
  name         = "${var.namespace}-run-updates-shadow"
  kms_key_name = var.crypto_key

  labels = var.labels
}

resource "google_pubsub_topic_iam_member" "run_updates_shadow" {
  topic  = google_pubsub_topic.run_updates_shadow.name
  role   = "roles/pubsub.admin"
  member = local.sa_member
}

resource "google_pubsub_subscription" "flat_run_fields_updater" {
  name  = "${var.namespace}-flat-run-fields-updater"
  topic = google_pubsub_topic.run_updates_shadow.name

  enable_message_ordering    = true
  message_retention_duration = "604800s" # 7 days.
  ack_deadline_seconds       = 60
  retry_policy {
    minimum_backoff = "1s"
    maximum_backoff = "600s"
  }

  labels = var.labels
}

resource "google_pubsub_subscription_iam_member" "flat_run_fields_updater" {
  subscription = google_pubsub_subscription.flat_run_fields_updater.name
  role         = "roles/pubsub.admin"
  member       = local.sa_member
}