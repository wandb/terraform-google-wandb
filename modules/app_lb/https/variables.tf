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

variable "ssl_certificate_id" {
  type        = string
  description = "The ID of the SSL certificate to use for the load balancer."
  default     = null
}

variable "fqdn" {
  type = string
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}
