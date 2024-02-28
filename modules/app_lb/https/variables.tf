variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "url_map" {
  type = object({ id = string })
}

variable "ip_address" {
  type = string
}

variable "fqdn" {
  type = string
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "enable_operator" {
  type        = bool
  description = "Boolean indicating if the new operator should be enabled"
  default     = false
}
