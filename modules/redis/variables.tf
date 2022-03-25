variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "labels" {
  description = "Labels which will be applied to all applicable resources."
  type        = map(string)
  default     = {}
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ id = string })
}