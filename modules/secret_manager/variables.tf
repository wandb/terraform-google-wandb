variable "project_id" {
  type        = string
  description = "The project ID to deploy to. If unset, the provider's default project is used."
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}
