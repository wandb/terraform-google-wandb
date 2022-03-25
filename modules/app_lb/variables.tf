variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}

variable "fqdn" {
  type        = string
  description = "The FQDN to the W&B application"
}

variable "ssl" {
  type        = bool
  default     = true
  description = "Enable SSL certificate"
}

variable "group" {
  type = string
}

variable "target_port" {
  type    = number
  default = 32543
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}