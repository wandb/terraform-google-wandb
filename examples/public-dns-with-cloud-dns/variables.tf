variable "allowed_inbound_cidrs" {
  type        = list(string)
  nullable    = false
  description = "Which IPv4 addresses/ranges to allow access. No default -- this must be explicitly provided."
}

variable "database_machine_type" {
  description = "Specifies the machine type to be allocated for the database"
  nullable    = false
  type        = string
}

variable "database_sort_buffer_size" {
  description = "Specifies the sort_buffer_size value to set for the database"
  type        = number
  default     = 262144
}
variable "disable_code_saving" {
  type        = bool
  description = "Boolean indicating if code saving is disabled"
  default     = false
}
variable "domain_name" {
  type        = string
  description = "Domain name for accessing the Weights & Biases UI."
}

variable "force_ssl" {
  description = "Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string"
  type        = bool
  default     = false
}
variable "gke_machine_type" {
  description = "Specifies the machine type to be allocated for the database"
  type        = string
  default     = "n1-standard-4"
}
variable "labels" {
  description = "A map of tags added to all resources"
  nullable    = false
  type        = map(string)
}
variable "license" {
  type = string
}
variable "namespace" {
  type        = string
  description = "Namespace prefix used for resources"
}
variable "project_id" {
  type        = string
  description = "Project ID"
}
variable "region" {
  type        = string
  description = "Google region"
}
variable "subdomain" {
  type        = string
  description = "Subdomain for access the Weights & Biases UI."
}
variable "wandb_version" {
  description = "The version of Weights & Biases local to deploy."
  type        = string
  default     = "latest"
}
variable "wandb_image" {
  description = "Docker repository of to pull the wandb image from."
  type        = string
  default     = "wandb/local"
}
variable "zone" {
  type        = string
  description = "Google zone"
}
