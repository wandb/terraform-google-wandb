output "bucket_name" {
  value = google_storage_bucket.file_storage.name
}

data "google_client_config" "current" {}

output "bucket_queue_name" {
  value = "${data.google_client_config.current.project}/${google_pubsub_topic.file_storage.name}/${google_pubsub_subscription.file_storage.name}"
}