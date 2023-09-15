data "google_project" "project" {}

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
  labels          = var.labels
  rotation_period = "100000s"
}



