variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "bucket_name" {
  type        = string
  description = "Existing bucket the service account will access"
  default     = ""
}


variable "create_workload_identity" {
  description = "Flag to indicate whether to create a workload identity for the service account."
  type        = bool
  default     = false
}

variable "kms_gcs_sa_id" {
  type    = string
  default = "wandb-serviceaccount"
}

variable "kms_gcs_sa_name" {
  type    = string
  default = "wandb-serviceaccount"
}

variable "enable_stackdriver" {
  type = bool
  default = false
}

variable "workload_account_id" {
  type    = string
  default = "stackdriver"
}

variable "service_account_name" {
  type    = string
  default = "stackdriver"
}