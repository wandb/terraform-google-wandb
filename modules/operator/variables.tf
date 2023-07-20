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
