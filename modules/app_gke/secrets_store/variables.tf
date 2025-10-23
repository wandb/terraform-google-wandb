variable "secrets_store_csi_driver_version" {
  type        = string
  description = "The version of the Secrets Store CSI Driver Helm chart to install."
}

variable "secrets_store_csi_driver_provider_gcp_version" {
  type        = string
  description = "The version of the GCP Secrets Manager Provider for Secrets Store CSI Driver Helm chart to install."
}
