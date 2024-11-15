variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
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