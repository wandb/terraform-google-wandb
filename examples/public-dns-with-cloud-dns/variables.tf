variable "allowed_inbound_cidrs" {
  type        = list(string)
  nullable    = false
  description = "Which IPv4 addresses/ranges to allow access. No default -- this must be explicitly provided."
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Google region"
}

variable "zone" {
  type        = string
  description = "Google zone"
}

variable "namespace" {
  type        = string
  description = "Namespace prefix used for resources"
}

variable "domain_name" {
  type        = string
  description = "Domain name for accessing the Weights & Biases UI."
}

variable "subdomain" {
  type        = string
  description = "Subdomain for access the Weights & Biases UI."
}

variable "gke_machine_type" {
  description = "Specifies the machine type to be allocated for the database"
  type        = string
  default     = "n1-standard-4"
}

variable "license" {
  type = string
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

variable "database_sort_buffer_size" {
  description = "Specifies the sort_buffer_size value to set for the database"
  type        = number
  default     = 262144
}

variable "force_ssl" {
  description = "Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string"
  type        = bool
  default     = false
}

variable "database_machine_type" {
  description = "Specifies the machine type to be allocated for the database"
  type        = string
  default     = "db-n1-standard-2"
}

variable "disable_code_saving" {
  type        = bool
  description = "Boolean indicating if code saving is disabled"
  default     = false
}

variable "size" {
  description = "Deployment size for the instance"
  type        = string
  default     = "small"
}
