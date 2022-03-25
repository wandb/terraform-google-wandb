resource "random_pet" "key_ring" {
  keepers = {
  }
}

resource "google_kms_key_ring" "default" {
  name     = "${var.namespace}-${random_pet.key_ring.id}"
  location = "global"
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

resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "pubsub.googleapis.com"
}

# PubSub service account must have roles/cloudkms.cryptoKeyEncrypterDecrypter to
# use pubsub topic encryption.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic#kms_key_name
resource "google_kms_crypto_key_iam_member" "pubsub_service_access" {
  crypto_key_id = google_kms_crypto_key.default.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.pubsub.email}"
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