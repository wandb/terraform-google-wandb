data "google_client_config" "current" {}
data "google_project" "project" {}
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

# For some reason we need this permission otherwise backend is throwing an error
# hopfully this is a short term fix.
resource "google_project_iam_member" "log_writer" {
  project = local.project_id
  role    = "roles/logging.logWriter"
  member  = local.sa_member
}

# If the bucket already exists, grant this new service account permission
resource "google_storage_bucket_iam_member" "object_admin" {
  count  = var.bucket_name != "" ? 1 : 0
  bucket = var.bucket_name
  member = local.sa_member
  role   = "roles/storage.objectAdmin"
}

# Required for W&B Secrets
resource "google_project_iam_member" "secretmanager_admin" {
  project = local.project_id
  member  = local.sa_member
  role    = "roles/secretmanager.admin"
}

####### service account for kms and gcs cross project access
resource "google_service_account" "kms_gcs_sa" {
  count        = var.workload_identity == true ? 1 : 0
  account_id   = var.kms_gcs_sa_id
  display_name = "Service Account For Workload Identity"
}

resource "google_project_iam_member" "storage" {
  count   = var.workload_identity == true ? 1 : 0
  project = local.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.kms_gcs_sa[count.index].email}"
}

resource "google_project_iam_member" "kms" {
  count   = var.workload_identity == true ? 1 : 0
  project = local.project_id
  role    = "roles/cloudkms.admin"
  member  = "serviceAccount:${google_service_account.kms_gcs_sa[count.index].email}"
}

resource "google_service_account_iam_member" "token_creator_binding" {
  count   = var.workload_identity == true ? 1 : 0
  service_account_id = google_service_account.kms_gcs_sa[count.index].id
  role    = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:${google_service_account.kms_gcs_sa[count.index].email}"
}

resource "google_service_account_iam_member" "workload_binding" {
  count   = var.workload_identity == true ? 1 : 0
  service_account_id = google_service_account.kms_gcs_sa[count.index].id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${local.project_id}.svc.id.goog[default/${var.kms_gcs_sa_name}]"
}