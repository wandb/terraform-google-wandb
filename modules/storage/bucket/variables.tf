variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "project_id" {
  type        = string
  default     = null
  description = "The project ID to deploy to. If unset, the provider's default project is used."
}

variable "crypto_key" {
  type        = string
  default     = null
  description = "Key used to encrypt and decrypt pubsub."
}

variable "public_access_prevention" {
  type        = string
  default     = "enforced"
  description = "Public access prevention for the bucket: `enforced` or `inherited`. Null leaves it unmanaged."
  validation {
    condition     = contains(["inherited", "enforced"], coalesce(var.public_access_prevention, "inherited"))
    error_message = "public_access_prevention must be null, \"inherited\" or \"enforced\"."
  }
}
