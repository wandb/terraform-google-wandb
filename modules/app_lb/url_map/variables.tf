variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "ip_address" {
  type = string
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

variable "allowed_inbound_cidr" {
  type        = list(string)
  default     = ["*"]
  description = "(Optional) Allow HTTP(S) traffic to W&B. Defaults to all connections."
}
