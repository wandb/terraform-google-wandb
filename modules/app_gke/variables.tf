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

variable "gke_version" {
  description = "Default GKE version"
  type        = string
  default     = "1.22.16-gke.2000"

  validation {
    condition     = regex("^1.2[2-4].*", var.gke_version)
    error_message = "We only support GKE: \"1.22\", \"1.23\" or \"1.24\"."
  }
}
