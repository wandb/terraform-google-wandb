
variable "namespace" {
  type        = string
  description = "(Required) String used for prefix resources."
}

variable "target_port" {
  type    = number
  default = 32543
}

variable "fqdn" {
  type = string
}