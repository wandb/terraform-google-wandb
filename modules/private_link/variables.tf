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

variable "region" {
  type        = string
  description = "The region where the resources will be deployed."
}

variable "subnetwork" {
  type = object({
    self_link = string
  })
  description = "The subnetwork object containing the self-link of the subnetwork."
}

variable "allowed_projects" {
  type = map(number)
  default = {}
  description = "A map of allowed projects where each key is a project number and the value is the connection limit."
}

variable "ingress_name" {
  description = "Name of the ingress resources which was created by wandb module"
  type        = string
}