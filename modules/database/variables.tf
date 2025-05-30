variable "project_id" {
  type        = string
  default     = null
  description = "Project ID"
}

variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "network_connection" {
  description = "The private service networking connection that will connect MySQL to the network."
  type        = object({ network = string })
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "tier" {
  type    = string
  default = "db-n1-standard-1"
}

variable "edition" {
  type        = string
  description = "The edition of the Cloud SQL instance. Can be either `STANDARD` or `ENTERPRISE` or `ENTERPRISE_PLUS`."
  default     = "ENTERPRISE"
}

variable "data_cache_enabled" {
  description = "Whether data cache is enabled for the Cloud SQL instance. This only applies to the `ENTERPRISE_PLUS` edition."
  type        = bool
  default     = false
  validation {
    condition     = !var.data_cache_enabled || var.edition == "ENTERPRISE_PLUS"
    error_message = "data_cache_enabled can only be true when edition is set to ENTERPRISE_PLUS."
  }
}
variable "availability_type" {
  type    = string
  default = "REGIONAL"
}


variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "database_version" {
  description = "Version for MySQL"
  type        = string
  default     = "MYSQL_8_0_31"
}

variable "database_flags" {
  description = "Flags to set for the database"
  type        = map(string)
  default     = {}
}

variable "sort_buffer_size" {
  description = "Specifies the sort_buffer_size value to set for the database"
  type        = number
  default     = 262144
}

variable "force_ssl" {
  description = "Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string"
  type        = bool
  default     = false
}

variable "crypto_key" {
  type        = string
  default     = null
  description = "Key used to encrypt and decrypt database."
}