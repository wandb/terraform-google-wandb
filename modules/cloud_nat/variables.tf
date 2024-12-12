variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}
variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}