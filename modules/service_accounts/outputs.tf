output "service_account" {
  value = google_service_account.main

  description = "The service account."
}

output "stackdriver_email" {
  value = var.enable_stackdriver == true ? google_service_account.stackdriver[0].email : null
}