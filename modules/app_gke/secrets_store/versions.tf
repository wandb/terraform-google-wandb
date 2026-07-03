terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}
