locals {
  sa_member = "serviceAccount:${var.service_account_email}"
}

resource "google_pubsub_topic" "filestream" {
  count        = var.enable_filestream ? 1 : 0
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
  count  = var.enable_filestream ? 1 : 0
  topic  = google_pubsub_topic.filestream[0].name
  role   = "roles/pubsub.admin"
  member = local.sa_member
}

resource "google_pubsub_subscription" "filestream-gorilla" {
  count = var.enable_filestream ? 1 : 0
  name  = "${var.namespace}-filestream-gorilla"
  topic = google_pubsub_topic.filestream[0].name

  # TODO(dpanzella): Uncomment if dead letter is needed.
  # dead_letter_policy {
  #   dead_letter_topic     = google_pubsub_topic.filestream_dead_letter[0].name
  #   max_delivery_attempts = 5
  # }

  message_retention_duration = "604800s" # 7 days.
  ack_deadline_seconds       = 30

  labels = var.labels
}

resource "google_pubsub_subscription_iam_member" "filestream-gorilla" {
  count        = var.enable_filestream ? 1 : 0
  subscription = google_pubsub_subscription.filestream-gorilla[0].name
  role         = "roles/pubsub.admin"
  member       = local.sa_member
}

resource "google_pubsub_topic" "run_updates_shadow" {
  count        = var.enable_flat_run_fields_updater ? 1 : 0
  name         = "${var.namespace}-run-updates-shadow"
  kms_key_name = var.crypto_key

  labels = var.labels
}

resource "google_pubsub_topic_iam_member" "run_updates_shadow" {
  count  = var.enable_flat_run_fields_updater ? 1 : 0
  topic  = google_pubsub_topic.run_updates_shadow[0].name
  role   = "roles/pubsub.admin"
  member = local.sa_member
}

resource "google_pubsub_subscription" "flat_run_fields_updater" {
  count = var.enable_flat_run_fields_updater ? 1 : 0
  name  = "${var.namespace}-flat-run-fields-updater"
  topic = google_pubsub_topic.run_updates_shadow[0].name

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
  count        = var.enable_flat_run_fields_updater ? 1 : 0
  subscription = google_pubsub_subscription.flat_run_fields_updater[0].name
  role         = "roles/pubsub.admin"
  member       = local.sa_member
}