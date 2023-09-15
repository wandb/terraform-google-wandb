variable "labels" {
  description = "A map of tags added to all resources"
  nullable    = false
  type        = map(string)
}

variable "machine_type" {
  type     = string
  nullable = false
}

variable "namespace" {
  description = "Friendly name prefix used for tagging and naming AWS resources."
  nullable    = false
  type        = string
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  nullable    = false
  type        = object({ self_link = string })
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  nullable    = false
  type        = object({ email = string })
}


variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  nullable    = false
  type        = object({ self_link = string })
}

