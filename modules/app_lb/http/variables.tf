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

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "use_new_ingress" {
  type        = bool
  description = "Boolean indicating if the new ingress should be used (true) or not (false). Default is false."
  default     = false
}
