variable "allowed_inbound_cidrs" {
  type        = list(string)
  nullable    = false
  default     = ["*"]
  description = "Which IPv4 addresses/ranges to allow access. No default -- this must be explicitly provided."
}

variable "create_redis" {
  default     = true
  description = "Boolean indicating whether to provision an redis instance (true) or not (false)."
  nullable    = false
  type        = bool
}

variable "project_id" {
  type        = string
  description = "Project ID"
  default     = ""
}

variable "region" {
  type        = string
  description = "Google region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Google zone"
  default     = "us-central1-b"
}

variable "namespace" {
  type        = string
  description = "Namespace prefix used for resources"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "Domain name for accessing the Weights & Biases UI."
  default     = ""
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

variable "license" {
  type    = string
  default = ""
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
  default     = null
}


variable "deletion_protection" {
  description = "If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "use_internal_queue" {
  type        = bool
  description = "Uses an internal redis queue instead of using google pubsub."
  default     = false
}


variable "oidc_issuer" {
  type        = string
  description = "A url to your Open ID Connect identity provider, i.e. https://cognito-idp.us-east-1.amazonaws.com/us-east-1_uiIFNdacd"
  default     = ""
}

variable "oidc_client_id" {
  type        = string
  description = "The Client ID of application in your identity provider"
  default     = ""
}

variable "oidc_secret" {
  type        = string
  description = "The Client secret of application in your identity provider"
  default     = ""
  sensitive   = true
}

variable "oidc_auth_method" {
  type        = string
  description = "OIDC auth method"
  default     = "implicit"
  validation {
    condition     = contains(["pkce", "implicit"], var.oidc_auth_method)
    error_message = "Invalid OIDC auth method."
  }
}

variable "local_restore" {
  type        = bool
  description = "Restores W&B to a stable state if needed"
  default     = false
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


variable "ssl" {
  type        = bool
  default     = true
  description = "Enable SSL certificate"
}

variable "database_version" {
  description = "Version for MySQL"
  type        = string
  default     = "MYSQL_8_0_31"
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


variable "bucket_name" {
  type        = string
  description = "Use an existing bucket."
  default     = ""
}

variable "gke_node_count" {
  type    = number
  default = 2
}

variable "other_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
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