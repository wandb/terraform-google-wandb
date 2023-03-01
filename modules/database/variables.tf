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
  default     = "MYSQL_8_0_29"

  validation {
    condition     = regex("^MYSQL_(8_0(_[0-9]*)?|5_7)$", var.database_version)
    error_message = "We only support MySQL: \"MYSQL_5_7\"; \"MYSQL_8_0\"."
  }
}

variable "sort_buffer_size" {
  description = "Specifies the sort_buffer_size value to set for the database"
  type        = number
  default     = 262144
}
