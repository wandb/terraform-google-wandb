variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "deletion_protection" {
  description = "If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "key_location" {
  type        = string
  description = "Location where the KMS key will be created."
}

variable "bind_pubsub_service_access" {
  type        = bool
  description = "Whether to bind the Pub/Sub service account to the KMS key for encrypter/decrypter access."
}