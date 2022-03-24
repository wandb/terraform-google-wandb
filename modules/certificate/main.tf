terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6"
    }
  }
}

# This IP address is the one you need to set in your cloud DNS as an A record.
# Make sure the domain and subdomain matchs the ones passed into this terraform
# module
resource "google_compute_global_address" "default" {
  name = "${var.namespace}-address"
}

locals {
  managed_certificate_name = "${var.namespace}-cert"
}

# Create SSL certificate for HTTPS connections. Note: it can take up to 2 hours
# for these certificates be provisioned
resource "kubernetes_manifest" "managed_certificate" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = local.managed_certificate_name
      namespace = "default"
    }

    spec = { domains = [var.fqdn] }
  }
}

# Create Loadbalancer using certifcate and IP address
resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "${var.namespace}-ingress"
    annotations = {
      "kubernetes.io/ingress.allow-http"            = false,
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.default.name,
      # "networking.gke.io/managed-certificates"      = local.managed_certificate_name,
    }
  }

  spec {
    backend {
      service_name = "wandb"
      service_port = 8080
    }
  }
}