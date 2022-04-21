variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "bucket_name" {
  type        = string
  description = "Existing bucket the service account will access"
  default     = ""
}