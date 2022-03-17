data "google_client_config" "current" {}

resource "random_id" "main" {
  # 30 bytes ensures that enough characters are generated to satisfy the service account ID requirements, regardless of
  # the prefix.
  byte_length = 30
  prefix      = "${var.namespace}-sa-"
}

resource "google_service_account" "main" {
  # Limit the string used to 30 characters.
  account_id   = substr(random_id.main.dec, 0, 30)
  display_name = "Weights & Biases"
  description  = "Service Account used by Weights & Biases."
}

# Creates a managed service account key (credentials key)
resource "google_service_account_key" "main" {
  service_account_id = google_service_account.main.name
}

locals {
  sa_member  = "serviceAccount:${google_service_account.main.email}"
  project_id = data.google_client_config.current.project
}

# Service Account Token Creator role allows principals to impersonate
# service accounts to create OAuth 2.0 tokens which can be used to
# authenticate with Google APIs 
resource "google_project_iam_member" "token_creator" {
  project = local.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = local.sa_member
}

# PubSub Admin role provides service account members 
# full access to topics and subscriptions
resource "google_project_iam_member" "pubsub_admin" {
  project = local.project_id
  role    = "roles/pubsub.admin"
  member  = local.sa_member
}

# Storage Object Admin role grants service account members
# full control of objects in a storage bucket
resource "google_project_iam_member" "storage_object_admin" {
  project = local.project_id
  role    = "roles/storage.objectAdmin"
  member  = local.sa_member
}

# Cloud SQL Client role allows service account members
# connectivity access to Cloud SQL instances
resource "google_project_iam_member" "cloudsql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = local.sa_member
}
