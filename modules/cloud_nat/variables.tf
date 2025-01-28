variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}
variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "proxy_nat" {
  description = "Enable NAT for the Load Balancer Proxy Subnets"
  type        = bool
}

variable "vpc_nat" {
  description = "Enable NAT for the VPC"
  type        = bool
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to all resources."
  default     = {}
}