variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "google_api_dns_override" {
  default     = false
  description = "By default we create PSC for all Google APIs at *.p.googleaps.com, this will additionally override the default *.googleapis.com domain as well"
  type        = bool
}