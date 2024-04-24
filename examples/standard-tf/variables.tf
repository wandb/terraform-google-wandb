variable "namespace" {
  type        = string
  description = "String used for prefix resources."
  default = ""
}

variable "project_id" {
  type        = string
  description = "Project ID"
  default = ""
}

variable "region" {
  type        = string
  description = "Google region"
  default = ""
}

variable "zone" {
  type        = string
  description = "Google zone"
  default = ""
}

variable "domain_name" {
  type        = string
  description = "Domain name for accessing the Weights & Biases UI."
  default = ""
}

variable "subdomain" {
  type        = string
  default     = null
  description = "Subdomain for access the Weights & Biases UI."
}

variable "gke_machine_type" {
  description = "Specifies the machine type to be allocated for the database"
  type        = string
  default     = "n1-standard-4"
}

variable "gke_node_count" {
  type    = number
  default = 2
}

variable "license" {
  type = string
  default = ""
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
  default     = null
}

variable "weave_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}

variable "app_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}

variable "parquet_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}
variable "other_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "wandb_version" {
  description = "The version of Weights & Biases local to deploy."
  type        = string
  default     = "latest"
}

variable "resource_limits" {
  description = "Specifies the resource limits for the wandb deployment"
  type        = map(string)
  default = {
    cpu    = null
    memory = null
  }
}

variable "resource_requests" {
  description = "Specifies the resource requests for the wandb deployment"
  type        = map(string)
  default = {
    cpu    = "2000m"
    memory = "2G"
  }
}


variable "allowed_inbound_cidrs" {
  default     = ["*"]
  description = "Which IPv4 addresses/ranges to allow access. This must be explicitly provided, and by default is set to [\"*\"]"
  nullable    = false
  type        = list(string)
}

variable "database_version" {
  description = "Version for MySQL"
  type        = string
  default     = "MYSQL_8_0_31"
}


variable "create_redis" {
  type        = bool
  description = "Boolean indicating whether to provision an redis instance (true) or not (false)."
  default     = true
}

variable "redis_reserved_ip_range" {
  type        = string
  description = "Reserved IP range for REDIS peering connection"
  default     = "10.30.0.0/16"
}

variable "redis_tier" {
  type        = string
  description = "Specifies the tier for this Redis instance"
  default     = "STANDARD_HA"
}