resource "random_pet" "key_ring" {
  keepers = {
  }
}

resource "google_kms_key_ring" "default" {
  name     = "${var.namespace}-${random_pet.key_ring.id}"
  location = var.key_location
}


# CryptoKeys cannot be deleted from Google Cloud Platform. Destroying a
# Terraform-managed CryptoKey will remove it from state and delete all
# CryptoKeyVersions, rendering the key unusable, but will not delete the
# resource from the project. When Terraform destroys these keys, any data
# previously encrypted with these keys will be irrecoverable. For this reason,
# it is strongly recommended that you add lifecycle hooks to the resource to
# prevent accidental destruction.
resource "google_kms_crypto_key" "default" {
  name            = "${var.namespace}-key"
  key_ring        = google_kms_key_ring.default.id
  rotation_period = "100000s"

  # lifecycle {
  #   prevent_destroy = var.deletion_protection
  # }
}

data "google_project" "project" {}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "sqladmin.googleapis.com"
}

resource "google_project_service_identity" "pubsub" {
  count    = var.bind_pubsub_service_to_kms_key ? 1 : 0
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "pubsub.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "pubsub_service_access" {
  count         = var.bind_pubsub_service_to_kms_key ? 1 : 0
  crypto_key_id = google_kms_crypto_key.default.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.pubsub[0].email}"
}

resource "google_project_service_identity" "bigtable" {
  count    = var.bind_bigtable_service_to_kms_key ? 1 : 0
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "bigtableadmin.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "bigtable_service_access" {
  count         = var.bind_bigtable_service_to_kms_key ? 1 : 0
  crypto_key_id = google_kms_crypto_key.default.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.bigtable[0].email}"
}


# Enable notifications by giving the correct IAM permission to the unique
# service account.
data "google_storage_project_service_account" "default" {
}

resource "google_kms_crypto_key_iam_member" "storage_service_access" {
  crypto_key_id = google_kms_crypto_key.default.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.default.email_address}"
}

data "google_storage_project_service_account" "gcs_account" {
}

locals {
  pubsub_members   = var.bind_pubsub_service_to_kms_key ? ["serviceAccount:${google_project_service_identity.pubsub[0].email}"] : []
  bigtable_members = var.bind_bigtable_service_to_kms_key ? ["serviceAccount:${google_project_service_identity.bigtable[0].email}"] : []
  members = concat([
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
    "serviceAccount:service-${data.google_project.project.number}@cloud-redis.iam.gserviceaccount.com",
  ], local.pubsub_members, local.bigtable_members)

}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {

  crypto_key_id = google_kms_crypto_key.default.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = local.members
}