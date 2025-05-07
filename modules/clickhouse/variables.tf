variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "network" {
  type        = string
  description = "Google Compute Engine network to which the cluster is connected."
}

variable "clickhouse_reserved_ip_range" {
  type        = string
  description = "Reserved IP range for ClickHouse private link"
  default     = "10.50.0.0/24"
}

variable "clickhouse_private_endpoint_service_name" {
  type        = string
  description = "ClickHouse private endpoint 'Service name' (ends in -clickhouse-cloud)."
  default     = ""

  validation {
    condition     = can(regex("-clickhouse-cloud$", var.clickhouse_private_endpoint_service_name))
    error_message = "ClickHouse Service name must end in '-clickhouse-cloud'."
  }
}

variable "clickhouse_region" {
  type        = string
  description = "ClickHouse region (us-east1, us-central1, etc)."
  default     = ""

  validation {
    condition     = length(var.clickhouse_region) > 0
    error_message = "Clickhouse Region should always be set if the private endpoint service name is specified."
  }
}

variable "clickhouse_provision_service" {
  type        = bool
  description = "Provision ClickHouse service"
  default     = false
}

variable "clickhouse_service_name" {
  type        = string
  description = "ClickHouse Service Name"
  default     = ""
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to all resources."
  default     = {}
}
