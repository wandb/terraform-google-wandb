output "bucket_name" {
  value = google_storage_bucket.file_storage.name
}

output "bucket_region" {
  value = google_storage_bucket.file_storage.location
}
