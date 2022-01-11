variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "instance_class" {
  description = "Instance type to use at master instance."
  type        = string
  default     = "db.r5.large"
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "teir" {
  type    = string
  default = "db-n1-standard-1"
}

variable "availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
}