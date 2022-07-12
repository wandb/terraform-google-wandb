variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}

variable "machine_type" {
  type    = string
  default = "n1-standard-4"
}