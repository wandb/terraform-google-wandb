output "bucket_name" {
  value = google_storage_bucket.file_storage.name
}

output "bucket_queue_name" {
  value = google_pubsub_topic.file_storage.id
}