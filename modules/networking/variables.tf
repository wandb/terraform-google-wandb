variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
}

variable "google_api_dns_override" {
  description = "By default we create PSC for all Google APIs at *.p.googleaps.com, this will additionally override the default *.googleapis.com domain as well"
  type        = bool
}

variable "google_api_dns_overrides" {
  description = "The subdomains to add to the override DNS zone"
  type        = list(string)
}

variable "google_api_psc_ipaddress" {
  description = "The global IP address for the Google API PSC, this should not overlap with the private IP range of the VPC.  Default to an address in the GC-NAT range, as that is least likely to interfere."
  type        = string
}
