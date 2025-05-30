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
  default     = "global"
}

variable "bind_pubsub_service_to_kms_key" {
  type        = bool
  description = "Whether to bind the Pub/Sub service account to the KMS key for encrypter/decrypter access."
  default     = true
}

variable "bind_bigtable_service_to_kms_key" {
  type        = bool
  description = "Whether to bind the Pub/Sub service account to the KMS key for encrypter/decrypter access."
  default     = true
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}