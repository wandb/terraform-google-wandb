variable "allowed_inbound_cidr" {
  description = "(Optional) Allow HTTP(S) traffic to W&B. Defaults to all connections."
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



