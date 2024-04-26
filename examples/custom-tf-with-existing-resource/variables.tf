variable "project_id" {
  type        = string
  description = "Project ID"
  default = ""
}

variable "region" {
  type        = string
  description = "Google region"
  default = "us-central1"
}

variable "zone" {
  type        = string
  description = "Google zone"
  default = "us-central1-b"
}

variable "namespace" {
  type        = string
  description = "Namespace prefix used for resources"
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


variable "license" {
  type = string
  default = ""
  }


variable "wandb_image" {
  description = "Docker repository of to pull the wandb image from."
  type        = string
  default     = "wandb/local"
}

variable "disable_code_saving" {
  type        = bool
  description = "Boolean indicating if code saving is disabled"
  default     = false
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

variable "create_redis" {
  type        = bool
  description = "Boolean indicating whether to provision an redis instance (true) or not (false)."
  default     = false
}

variable "redis_cluster_name" {
  type = string
  default = ""
}

variable "redis_env" {
  nullable    = false
  type = object({
    password = string
    host     = string
    port     = string
    connection_string = string
  })

  default = {
    password = "***"
    host     = "**"
    port     = "6378"
    connection_string = "redis://:<password>@<host>:6378?tls=true&caCertPath=/etc/ssl/certs/redis_ca.pem&ttlInSeconds=604800"
  }
}
variable "network" {
  nullable    = false
  default     = ""
  description = "Pre-existing network self link"
  type        = string
}

variable "subnetwork" {
  nullable    = false
  default     = ""
  description = "Pre-existing subnetwork self link"
  type        = string
}

variable "create_database" {
  type        = bool
  default     = false
}

variable "database_env" {
  nullable    = false
  type = object({
    name               = string
    database_name      = string
    username           = string
    password           = string
    private_ip_address = string
    connection_string  = string
  })

  default = {
    name = "**"
    username = "**"
    password = "**"
    database_name =  "**"
    private_ip_address =  "**"
    connection_string = "**" # "mysql://${username}:${password}@${private_ip_address}/${database_name}"
  }
}

variable "cluster_name" {
  type = string
  description = "gke cluster name where you wanted to host your workload"
  default = ""
}

variable "create_gke" {
  type = bool
  default = false
}