terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.39"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.9"
    }
  }
}