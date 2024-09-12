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
}

variable "kms_gcs_sa_list" {
  type = list(string)
}

variable "stackdriver_sa_name" {
  description = "The name of the service account."
  type        = string
}

variable "enable_stackdriver" {
  description = "Flag to indicate whether to enable workload identity for the service account."
  type        = bool
}

variable "skip_bucket_admin_role" {
  description = "Flag to indicate whether to skip the bucket policy creation."
  type        = bool
}