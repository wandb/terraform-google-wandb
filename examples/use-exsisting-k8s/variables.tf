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

variable "network" {
  default     = null
  description = "Pre-existing network self link"
  type        = string
}

variable "subnetwork" {
  default     = null
  description = "Pre-existing subnetwork self link"
  type        = string
}

variable "allowed_inbound_cidr" {
  type        = list(string)
  default     = ["*"]
  description = "(Optional) Allow HTTP(S) traffic to W&B. Defaults to all connections."
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "cluster_location" {
  description = "The location (region/zone) of the cluster"
  type        = string
}

variable "instance_group_url" {
  description = "The URL of the instance group"
  type        = string
  # Example:
  # instance_group_url = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/zones/us-central1-a/instanceGroups/my-instance-group"
}