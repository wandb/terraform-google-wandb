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
  description = "The cluster name for labeling"
}

variable "bufstream_namespace" {
  type        = string
  description = "The Kubernetes namespace where Bufstream will run"
}

variable "bufstream_service_account" {
  type        = string
  description = "The Kubernetes service account name for Bufstream"
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to resources"
  default     = {}
}
