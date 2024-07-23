variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ id = string })
}

variable "memory_size_gb" {
  description = "The amount of memory which will be allocated to the Redis instance; this value must be expressed in gibibytes."
  type        = number
}

variable "reserved_ip_range" {
  description = "This defines the IP range for REDIS peering connection"
  type        = string
}

variable "tier" {
  type        = string
  description = "Specifies the tier for this Redis instance"
}

variable "crypto_key" {
  type        = string
  default     = null
  description = "Key used to encrypt and decrypt redis."
}