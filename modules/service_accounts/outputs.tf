output "service_account" {
  value = google_service_account.main
  description = "The service account."
}

output "sa_account_role" {
  value = var.create_workload_identity == true ? google_service_account.kms_gcs_sa[0].email : null
}

output "stackdriver_role" {
  value = var.enable_stackdriver == true ? google_service_account.stackdriver[0].email : null
}