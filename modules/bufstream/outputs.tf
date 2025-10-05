output "bucket_name" {
  description = "The name of the Bufstream storage bucket"
  value       = google_storage_bucket.bufstream.name
}

output "service_account_email" {
  description = "The email of the Bufstream service account"
  value       = google_service_account.bufstream.email
}
