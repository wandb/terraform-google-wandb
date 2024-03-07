variable "allowed_inbound_cidrs" {
  description = "Which IPv4 addresses/ranges to allow access. No default -- this must be explicitly provided."
  nullable    = false
  type        = list(string)
}

variable "fqdn" {
  type        = string
  description = "The FQDN to the W&B application"
}

variable "group" {
  type = string
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}
variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}
variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}
variable "ssl" {
  type        = bool
  default     = true
  description = "Enable SSL certificate"
}
variable "target_port" {
  type    = number
  default = 32543
}

variable "ip_address" {
  type = string
}

variable "certificate_id" {
  type = string
}

