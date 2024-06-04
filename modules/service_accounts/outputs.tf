output "service_account" {
  value = google_service_account.main

  description = "The service account."
}

output "monitoring_role" {
  value = var.enable_stackdriver == true ? google_service_account.workload-identity-user-sa[0].email : null
}