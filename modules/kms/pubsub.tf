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
