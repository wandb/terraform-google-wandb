terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.7"
    }
  }
}
