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

variable "forwarding_rule" {
  type        = string
  description = "forwarding rule name used in private service connect as a target"
}