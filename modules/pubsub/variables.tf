variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
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
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "crypto_key" {
  type        = string
  default     = null
  description = "Key used to encrypt and decrypt database."
}

variable "enable_filestream" {
  type        = bool
  default     = false
  description = "Enable the filestream service. (This also requires create_pubsub and create_bigtable to be true)"
}
variable "enable_flat_run_fields_updater" {
  type        = bool
  default     = false
  description = "Enable the run updates shadow service."
}