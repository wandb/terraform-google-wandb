variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "create_queue" {
  type    = bool
  default = true
}

variable "crypto_key" {
  type        = string
  default     = null
  description = "Key used to encrypt and decrypt pubsub."
}

variable "bucket_crypto_key" {
  type        = string
  default     = null
  description = "Key used to encrypt and decrypt storage bucket."
}

variable "project_id" {
  type        = string
  default     = null
  description = "The project ID to deploy to. If unset, the provider's default project is used."
}
