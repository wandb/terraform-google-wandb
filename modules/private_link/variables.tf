variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  type = object({
    self_link = string
  })
  description = "The subnetwork object containing the self-link of the subnetwork."
}

variable "allowed_project_names" {
  type        = map(number)
  default     = {}
  description = "A map of allowed projects where each key is a project number and the value is the connection limit."
}

variable "psc_subnetwork" {
  type        = string
  description = "Private link service reserved subnetwork"
}

variable "proxynetwork_cidr" {
  type        = string
  description = "Internal load balancer proxy subnetwork"
}

variable "fqdn" {
  type        = string
  description = "Fully qualified domain name or hostname"
}