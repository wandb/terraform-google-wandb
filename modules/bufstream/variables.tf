variable "namespace" {
  type        = string
  description = "The namespace for the bufstream resources"
}

variable "region" {
  type        = string
  description = "The region for the bufstream bucket"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "cluster_name" {
  type        = string
  description = "The GKE cluster name for labeling"
}

variable "k8s_namespace" {
  type        = string
  description = "The Kubernetes namespace where Bufstream will run"
  default     = "bufstream"
}

variable "k8s_service_account" {
  type        = string
  description = "The Kubernetes service account name for Bufstream"
  default     = "bufstream-service-account"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection on the bucket"
  default     = true
}
