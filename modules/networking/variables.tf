variable "labels" {
  description = "A map of tags added to all resources"
  nullable    = false
  type        = map(string)
}
variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}
