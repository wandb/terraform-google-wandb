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

locals {
  sa_member  = "serviceAccount:${google_service_account.main.email}"
  project_id = data.google_client_config.current.project
}

resource "random_string" "role_suffix" {
  length  = 24
  special = false
}

locals {
  title_namespace = title(replace(var.namespace, "-", " "))
  camel_namespace = replace(local.title_namespace, " ", "")
}

resource "google_project_iam_custom_role" "sign_blobs" {
  role_id     = "${local.camel_namespace}SignBlobs${random_string.role_suffix.result}"
  title       = "Sign Blobs - ${var.namespace}"
  description = "Role used to give Weights & Biases deployment permission to sign blobs."
  permissions = ["iam.serviceAccounts.signBlob"]
}

resource "google_project_iam_member" "sign_blobs" {
  project = data.google_client_config.current.project
  role    = google_project_iam_custom_role.sign_blobs.id
  member  = local.sa_member
  # condition {
  #   title       = "bucket_access"
  #   description = "Only access deployments bucket"
  #   expression  = "resource.name.startsWith('projects/_/buckets/${google_storage_bucket.file_storage.name}')"
  # }
}


# # Service Account Token Creator role allows principals to impersonate service
# # accounts to create OAuth 2.0 tokens which can be used to authenticate with
# # Google APIs 
# resource "google_project_iam_member" "token_creator" {
#   project = local.project_id
#   role    = "roles/iam.serviceAccountTokenCreator"
#   member  = local.sa_member
#   condition {
#     title       = "bucket_access"
#     description = "Only access deployments bucket"
#     condition   = "resource.type == 'storage.googleapis.com/Bucket' && resource.name == '${var.bucket_name}'"

#   }
# }

# data "google_compute_default_service_account" "default" {
# }

# resource "google_service_account_iam_member" "gce_default_token_creator" {
#   service_account_id = data.google_compute_default_service_account.default.name
#   role               = "roles/iam.serviceAccountTokenCreator"
#   member             = local.sa_member
# }

# resource "google_service_account_iam_member" "storage_default_token_creator" {
#   service_account_id = data.google_app_engine_default_service_account.default.name
#   role               = "roles/iam.serviceAccountTokenCreator"
#   member             = local.sa_member
# }

# Cloud SQL Client role allows service account members connectivity access to
# Cloud SQL instances
resource "google_project_iam_member" "cloudsql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = local.sa_member
}
