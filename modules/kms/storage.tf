# Enable notifications by giving the correct IAM permission to the unique
# service account.

data "google_storage_project_service_account" "default" {
}

resource "google_kms_crypto_key_iam_member" "storage_service_access" {
  crypto_key_id = google_kms_crypto_key.default.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.default.email_address}"
}