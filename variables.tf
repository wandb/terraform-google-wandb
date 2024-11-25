##########################################
# Common                                 #
##########################################
variable "namespace" {
  type        = string
  description = "String used for prefix resources."
}

variable "deletion_protection" {
  description = "If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
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

variable "license" {
  type        = string
  description = "Your wandb/local license"
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

##########################################
# Operator                               #
##########################################
variable "operator_chart_version" {
  type        = string
  description = "Version of the operator chart to deploy"
  default     = "1.3.4"
}

variable "controller_image_tag" {
  type        = string
  description = "Tag of the controller image to deploy"
  default     = "1.14.0"
}

##########################################
# Networking                             #
##########################################
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

variable "allowed_inbound_cidrs" {
  default     = ["*"]
  description = "Which IPv4 addresses/ranges to allow access. This must be explicitly provided, and by default is set to [\"*\"]"
  nullable    = false
  type        = list(string)
}


##########################################
# DNS                                    #
##########################################
variable "domain_name" {
  type        = string
  default     = null
  description = "Domain for accessing the Weights & Biases UI."
}

variable "subdomain" {
  type        = string
  default     = null
  description = "Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route."
}

variable "ssl" {
  type        = bool
  default     = true
  description = "Enable SSL certificate"
}

##########################################
# Database                               #
##########################################
variable "database_version" {
  description = "Version for MySQL"
  type        = string
  default     = "MYSQL_8_0_31"
}

variable "database_machine_type" {
  description = "Specifies the machine type to be allocated for the database. Defaults to null and value from deployment-size.tf is used"
  type        = string
  default     = null
}

variable "database_edition" {
  description = "The edition of the Cloud SQL instance. Can be either `STANDARD` or `ENTERPRISE` or `ENTERPRISE_PLUS`."
  type        = string
  default     = "ENTERPRISE"
}

variable "database_sort_buffer_size" {
  description = "Specifies the sort_buffer_size value to set for the database"
  type        = number
  default     = 67108864
}

variable "database_max_allowed_packet" {
  description = "Specifies the max_allowed_packet value to set for the database"
  type        = number
  default     = 67108864
}

variable "force_ssl" {
  description = "Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string"
  type        = bool
  default     = false
}

##########################################
# BigTable                               #
##########################################
variable "create_bigtable" {
  type        = bool
  description = "Boolean indicating whether to provision a bigtable instance (true) or not (false)."
  default     = false
}

variable "bigtable_storage_type" {
  type        = string
  description = "The storage type for the Bigtable cluster."
  default     = "SSD"
}

variable "bigtable_min_nodes" {
  type        = number
  description = "The minimum number of nodes for the Bigtable cluster."
  default     = 1
}

variable "bigtable_max_nodes" {
  type        = number
  description = "The maximum number of nodes for the Bigtable cluster."
  default     = 3
}

variable "bigtable_cpu_target" {
  type        = number
  description = "The target CPU utilization for the Bigtable cluster."
  default     = 70
}

##########################################
# PubSub                                 #
##########################################
variable "create_pubsub" {
  type        = bool
  description = "Boolean indicating whether to provision a bigtable instance (true) or not (false)."
  default     = false
}

##########################################
# Redis                                  #
##########################################
variable "create_redis" {
  type        = bool
  description = "Boolean indicating whether to provision an redis instance (true) or not (false)."
  default     = false
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

variable "redis_memory_size_gb" {
  type        = number
  description = "Specifies the memory size in GB for the Redis instance. Defaults to null and value from deployment-size.tf is used"
  default     = null
}

##########################################
# External Bucket                        #
##########################################
# Most users will not need these settings. They are meant for users who want a
# bucket in a different account.

variable "bucket_name" {
  type        = string
  description = "Use an existing bucket."
  default     = ""
}

variable "bucket_location" {
  type        = string
  description = "Location of the bucket (US, EU, ASIA)"
  default     = "US"
}

variable "skip_bucket_admin_role" {
  type        = bool
  description = "Flag to indicate whether to skip the bucket policy creation."
  default     = false
}
##########################################
# Bucket Subpath                         #
##########################################
# This setting is meant for users who want to store all of their instance-level
# bucket's data at a specific path within their bucket. It can be set both for
# external buckets or the bucket created by this module.
variable "bucket_path" {
  description = "path of where to store data for the instance-level bucket"
  type        = string
  default     = ""
}

##########################################
# K8s                                    #
##########################################

variable "gke_machine_type" {
  description = "Specifies the machine type for nodes in the GKE cluster. Defaults to null and value from deployment-size.tf is used"
  type        = string
  default     = null
}


variable "gke_min_node_count" {
  type        = number
  description = "Initial number of nodes for the GKE cluster, if gke_max_node_count is set, this is the minimum number of nodes. Defaults to null and value from deployment-size.tf is used"
  default     = null
}

variable "gke_max_node_count" {
  type        = number
  description = "Maximum number of nodes for the GKE cluster. Defaults to null and value from deployment-size.tf is used"
  default     = null
}

##########################################
# General Application                    #
##########################################

variable "disable_code_saving" {
  type        = bool
  description = "Boolean indicating if code saving is disabled"
  default     = false
}

variable "other_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}

variable "enable_filestream" {
  type        = bool
  description = "Enable Filestream Service (this will implicitly enable pubsub and bigtable)"
  default     = false
}

variable "enable_flat_run_fields_updater" {
  type        = bool
  description = "Enable Flat Run Fields Updater Service"
  default     = false
}

##########################################
# KMS                                    #
##########################################
variable "sql_default_encryption" {
  description = "Boolean to determine if a default SQL encryption key should be used. If true, a default key will be created. Takes precedence over `db_kms_key_id`."
  type        = bool
  default     = false
}

variable "bucket_default_encryption" {
  description = "Boolean to determine if a default bucket encryption key should be used. If true, a default key will be created. Takes precedence over `bucket_kms_key_id`."
  type        = bool
  default     = false
}

variable "db_kms_key_id" {
  description = "ID of the customer-provided SQL KMS key."
  type        = string
  default     = null
}

variable "bucket_kms_key_id" {
  description = "ID of the customer-provided bucket KMS key."
  type        = string
  default     = null
}

variable "size" {
  description = "Deployment size for the instance"
  type        = string
  default     = "small"
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

##########################################
# private link                           #
##########################################

## In order to support private link required min version 0.13.0 of operator-wandb chart

variable "create_private_link" {
  type        = bool
  description = "Whether to create a private link service."
  default     = false
}

variable "public_access" {
  type        = bool
  description = "Whether to create a public endpoint for wandb access."
  default     = true
}

variable "allowed_project_names" {
  type = map(number)
  default = {
    # "project_ID" = 4 
  }
  description = "A map of allowed projects where each key is a project number and the value is the connection limit."
}

variable "psc_subnetwork_cidr" {
  default     = "192.168.0.0/24"
  description = "Private link service reserved subnetwork"
  type        = string
}

variable "ilb_proxynetwork_cidr" {
  default     = "10.127.0.0/24"
  description = "Internal load balancer proxy subnetwork"
  type        = string
}

variable "create_workload_identity" {
  description = "Flag to indicate whether to create a workload identity for the service account."
  type        = bool
  default     = false
}


variable "enable_stackdriver" {
  type    = bool
  default = false
}

variable "stackdriver_sa_name" {
  type    = string
  default = "wandb-stackdriver"
}

###########################################
# ClickHouse endpoint                     #
###########################################
variable "clickhouse_private_endpoint_service_name" {
  type        = string
  description = "ClickHouse private endpoint 'Service name' (ends in -clickhouse-cloud)."
  default     = ""
}

variable "clickhouse_region" {
  type        = string
  description = "ClickHouse region (us-east1, us-central1, etc)."
  default     = ""
}

variable "clickhouse_subnetwork_cidr" {
  default     = "10.50.0.0/24"
  description = "ClickHouse private service connect subnetwork"
  type        = string
}
