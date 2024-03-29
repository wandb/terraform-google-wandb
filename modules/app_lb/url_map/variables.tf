variable "allowed_inbound_cidrs" {
  description = "Which IPv4 addresses/ranges to allow access. No default -- this must be explicitly provided."
  nullable    = false
  type        = list(string)
}

variable "group" {
  type = string
}

variable "ip_address" {
  type = string
}

variable "namespace" {
  description = "Friendly name prefix used for tagging and naming AWS resources."
  type        = string
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "target_port" {
  default = 32543
  type    = number
}



