variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "bucket_name" {
  type        = string
  description = "Existing bucket the service account will access"
  default     = ""
}

variable "account_id" {
  description = "The ID of the Google Cloud Platform (GCP) account."
  type        = string
}

variable "service_account_name" {
  description = "The name of the service account."
  type        = string
}

variable "enable_stackdriver" {
  description = "Flag to indicate whether to enable workload identity for the service account."
  type        = bool
}