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

resource "google_service_account_key" "main" {
  service_account_id = google_service_account.main.name
}

resource "google_project_iam_binding" "token_creator_binding" {
  project = "your-project-id" // project_id is null as part of the root main.tf
  role    = [
  "roles/iam.serviceAccountTokenCreator",
  "roles/pubsub.admin",
  "roles/composer.environmentAndStorageObjectAdmin",
  "roles/cloudsql.client"
] 
  members = "serviceAccount:${google_service_account.sa-name.email}"
}
