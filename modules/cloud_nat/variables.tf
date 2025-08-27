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

variable "proxy_nat_min_ports_per_vm" {
  description = "Minimum number of ports to allocate per VM for the Load Balancer Proxy NAT."
  type        = number
  default     = 64
}

variable "proxy_nat_max_ports_per_vm" {
  description = "Maximum number of ports to allocate per VM for the Load Balancer Proxy NAT."
  type        = number
  default     = 65536
}

variable "proxy_nat_enable_dynamic_port_allocation" {
  description = "Enable dynamic port allocation for the Load Balancer Proxy NAT"
  type        = bool
  default     = true
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