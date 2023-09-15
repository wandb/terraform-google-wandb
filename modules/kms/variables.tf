variable "deletion_protection" {
  description = "If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "labels" {
  description = "A map of tags added to all resources"
  nullable    = false
  type        = map(string)
}

variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}
