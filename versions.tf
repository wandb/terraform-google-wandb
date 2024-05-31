terraform {
  required_version = "~> 1.0"
  required_providers {
    time_sleep = {
      source = "hashicorp/time"
      version = "~> 0.10.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.82"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}
