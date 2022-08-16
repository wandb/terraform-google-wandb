##########################################
# Common                                 #
##########################################
variable "namespace" {
  type        = string
  description = "String used for prefix resources."
}

variable "deletion_protection" {
  description = "If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "use_internal_queue" {
  type        = bool
  description = "Uses an internal redis queue instead of using google pubsub."
  default     = false
}

variable "wandb_version" {
  description = "The version of Weights & Biases local to deploy."
  type        = string
  default     = "latest"
}

variable "wandb_image" {
  description = "Docker repository of to pull the wandb image from."
  type        = string
  default     = "wandb/local"
}

variable "license" {
  type        = string
  description = "Your wandb/local license"
}

variable "oidc_issuer" {
  type        = string
  description = "A url to your Open ID Connect identity provider, i.e. https://cognito-idp.us-east-1.amazonaws.com/us-east-1_uiIFNdacd"
  default     = ""
}

variable "oidc_client_id" {
  type        = string
  description = "The Client ID of application in your identity provider"
  default     = ""
}

variable "oidc_secret" {
  type        = string
  description = "The Client secret of application in your identity provider"
  default     = ""
}

variable "oidc_auth_method" {
  type        = string
  description = "OIDC auth method"
  default     = "implicit"
  validation {
    condition     = contains(["pkce", "implicit"], var.oidc_auth_method)
    error_message = "Invalid OIDC auth method."
  }
}

##########################################
# Networking                             #
##########################################
variable "network" {
  default     = null
  description = "Pre-existing network self link"
  type        = string
}

variable "subnetwork" {
  default     = null
  description = "Pre-existing subnetwork self link"
  type        = string
}


##########################################
# DNS                                    #
##########################################
variable "domain_name" {
  type        = string
  default     = null
  description = "Domain for accessing the Weights & Biases UI."
}

variable "subdomain" {
  type        = string
  default     = null
  description = "Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route."
}

variable "ssl" {
  type        = bool
  default     = true
  description = "Enable SSL certificate"
}

##########################################
# Database                               #
##########################################
variable "database_version" {
  description = "Version for MySQL"
  type        = string
  default     = "MYSQL_8_0"

  validation {
    condition     = contains(["MYSQL_5_7", "MYSQL_8_0"], var.database_version)
    error_message = "We only support MySQL: \"MYSQL_5_7\"; \"MYSQL_8_0\"."
  }
}

variable "database_sort_buffer_size" {
  description = "Specifies the sort_buffer_size value to set for the database"
  type        = number
  default     = 262144
}

##########################################
# Redis                                  #
##########################################
variable "create_redis" {
  type        = bool
  description = "Boolean indicating whether to provision an redis instance (true) or not (false)."
  default     = false
}

##########################################
# External Bucket                        #
##########################################
# Most users will not need these settings. They are ment for users who want a
# bucket in a different account.

variable "bucket_name" {
  type        = string
  description = "Use an existing bucket."
  default     = ""
}