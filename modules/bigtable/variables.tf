variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "service_account_email" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = string
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

variable "storage_type" {
  type        = string
  description = "The storage type for the Bigtable cluster."
}

variable "min_nodes" {
  type        = number
  description = "The minimum number of nodes for the Bigtable cluster."
}

variable "max_nodes" {
  type        = number
  description = "The maximum number of nodes for the Bigtable cluster."
}

variable "cpu_target" {
  type        = number
  description = "The target CPU utilization for the Bigtable cluster."
}