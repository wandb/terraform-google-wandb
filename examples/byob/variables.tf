variable "allowed_inbound_cidrs" {
  type        = list(string)
  nullable    = false
  description = "Which IPv4 addresses/ranges to allow access. No default -- this must be explicitly provided."
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Google region"
}

variable "zone" {
  type        = string
  description = "Google zone"
}

variable "bucket_location" {
  type        = string
  description = "Location of the bucket (US, EU, ASIA)"
  default     = "US"
}

variable "bucket_prefix" {
  type        = string
  description = "String used for prefix resources."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "service_account_email" {
  type        = string
  description = "Service account to grant permission too."
  default     = "deploy@wandb-production.iam.gserviceaccount.com"
}

variable "deletion_protection" {
  description = "Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}
