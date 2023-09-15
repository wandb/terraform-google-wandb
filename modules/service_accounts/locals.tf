locals {
  project_id = data.google_client_config.current.project
  sa_member  = "serviceAccount:${google_service_account.main.email}"
}
