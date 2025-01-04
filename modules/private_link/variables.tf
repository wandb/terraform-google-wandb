variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ id = string })
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

variable "psc_subnetwork_cidr" {
  type        = string
  description = "Private link service reserved subnetwork CIDR range"
}

variable "ilb_proxynetwork_cidr" {
  type        = string
  description = "CIDR range for the internal load balancer proxy subnet"
}

variable "ilb_name" {
  type        = string
  description = "Name of the internal load balancer"
}
