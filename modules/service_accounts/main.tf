data "google_client_config" "current" {}

resource "google_service_account" "main" {
  # Limit the string used to 30 characters.
  account_id   = "${var.namespace}-sa"
  display_name = "Service Account for ${var.namespace}"
  description  = "Service Account used by Weights & Biases."
}

locals {
  sa_member  = "serviceAccount:${google_service_account.main.email}"
  project_id = data.google_client_config.current.project
}

# The only permission we care about is `iam.serviceAccounts.signBlob`. W&B signs
# blobs using the account it is currently logged in with. Technically we dont
# need all the permissions `serviceAccountTokenCreator` offers, but creating a
# new custom role, requires more confusing terraform. Instead we can simply
# scope this role to the itself.
resource "google_service_account_iam_member" "token_creator" {
  service_account_id = google_service_account.main.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = local.sa_member
}

# Cloud SQL Client role allows service account members connectivity access to
# Cloud SQL instances
resource "google_project_iam_member" "cloudsql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = local.sa_member
}
