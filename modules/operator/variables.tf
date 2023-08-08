variable "bucket" {
  type        = string
  description = "The S3 / GCS bucket for storing data"
}

variable "fqdn" {
  type        = string
  description = "The FQD of your instance."
}

variable "address_name" {
  type = string
}

variable "database" {
  type = object({
    name     = string
    user     = string
    password = string
    database = string
    host     = string
    port     = number
  })
}

variable "redis" {
  type = object({
    user     = string
    password = string
    host     = string
    port     = number
    caCert   = string
    params   = any
  })
}