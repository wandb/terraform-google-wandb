variable "namespace" {
  type        = string
  description = "Prefix to use when creating resources"
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  nullable    = false
  type        = map(string)
}

variable "bucket_location" {
  type        = string
  description = "Location of the bucket (US, EU, ASIA)"
  default     = "US"
}

variable "service_account_email" {
  type        = string
  description = "Service account that can access the bucket"
}

variable "deletion_protection" {
  description = "Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = false
}


