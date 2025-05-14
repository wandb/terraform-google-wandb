variable "namespace" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Weights & Biases."
  type        = object({ email = string })
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}

variable "machine_type" {
  type = string
}

variable "weave_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}

variable "app_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}

variable "parquet_wandb_env" {
  type        = map(string)
  description = "Extra environment variables for W&B"
  default     = {}
}


variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the node root volume in GB."
  default     = "100"
}

variable "create_workload_identity" {
  description = "Flag to indicate whether to enable workload identity for the service account."
  type        = bool
}

variable "enable_private_gke_nodes" {
  type        = bool
  description = "Enable private nodes for the GKE cluster."
}

variable "enable_gcs_fuse_csi_driver" {
  type        = bool
  description = "Enable GCS Fuse CSI driver for the GKE cluster."
  default     = false
}

variable "deletion_protection" {
  description = "If the GKE Cluster should have deletion protection enabled. The GKE Cluster can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "release_channel" {
  description = "The release channel for the GKE cluster. Can be one of `RAPID`, `REGULAR`, or `STABLE`."
  type        = string
  default     = "STABLE"
}

variable "gke_min_version" {
  description = "The GKE version for the cluster. If not set, the default version for the selected release channel will be used."
  type        = string
  default     = ""
}