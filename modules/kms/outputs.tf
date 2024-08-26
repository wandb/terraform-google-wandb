output "crypto_key" {
  value = google_kms_crypto_key.default
}
output "google_kms_crypto_key_iam_binding" {
  value = google_kms_crypto_key_iam_binding.crypto_key
}