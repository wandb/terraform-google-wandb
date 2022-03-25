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
  default     = "MYSQL_5_7"

  validation {
    condition     = contains(["MYSQL_5_7", "MYSQL_8_0"], var.database_version)
    error_message = "We only support MySQL: \"MYSQL_5_7\"; \"MYSQL_8_0\"."
  }
}
