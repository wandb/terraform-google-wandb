provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Spin up all required services
module "wandb_infra" {
  source = "../../"

  namespace = var.namespace

  domain_name = var.domain
  subdomain   = var.subdomain

  deletion_protection = false
}


data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${module.wandb_infra.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.wandb_infra.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

# Deploy application into kubernetes cluster that was just created
module "wandb_app" {
  source = "github.com/wandb/terraform-kubernetes-wandb"

  license = var.license

  host                       = module.wandb_infra.url
  bucket                     = "gs://${module.wandb_infra.bucket_name}"
  bucket_queue               = "pubsub:/${module.wandb_infra.bucket_queue_name}"
  database_connection_string = "mysql://${module.wandb_infra.database_connection_string}"

  # If we dont wait, tf will start trying to deploy while the work group is
  # still spinning up
  depends_on = [module.wandb_infra]
}

# At this point terraform the instance is running in a private gke cluster Now
# we will deploy an ingress and SSL certificate to expose it publicly. You'll
# want to update your DNS with the provisioned API

# Create public IP. This IP address is the one you need to set in your cloud DNS
# as an A record. Make sure the domain and subdomain matchs the ones passed into
# this terraform module
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

    spec = {
      domains = [module.wandb_infra.fqdn]
    }
  }
}

# Create Loadbalancer
resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "${var.namespace}-ingress"
    annotations = {
      "kubernetes.io/ingress.allow-http"            = false
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.default.name,
      "networking.gke.io/managed-certificates"      = local.managed_certificate_name,
    }
  }

  spec {
    backend {
      service_name = "wandb"
      service_port = 8080
    }
  }
}

output "url" {
  value = module.wandb_infra.url
}

output "ip_address" {
  value = google_compute_global_address.default.address
}