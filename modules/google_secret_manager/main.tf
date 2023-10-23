locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "google_project_iam_member" "secret_accessor" {
  project = var.project_id
  member  = local.sa_member
  role    = "roles/secretmanager.admin"
}
