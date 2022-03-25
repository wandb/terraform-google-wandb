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