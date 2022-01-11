variable "project_id" {
  type = string
  description = "Project ID"
}

variable "namespace" {
  type        = string
  description = "Namespace prefix used for resources"
}

variable "domain" {
  type        = string
  default     = "wandb.io"
  description = "Domain for access the Weights & Biases UI."
}

variable "subdomain" {
  type        = string
  default     = "wandb"
  description = "Subdomain for access the Weights & Biases UI."
}

variable "license" {
  type = string
}