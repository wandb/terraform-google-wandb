provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "wandb_infra" {
  source = "../../"

  namespace = var.namespace

  domain_name = var.domain
  subdomain   = var.subdomain

  deletion_protection = false
}


data "google_client_config" "current" {
}

provider "kubernetes" {
  host                   = "https://${module.wandb_infra.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.wandb_infra.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}


module "wandb_app" {
  source = "github.com/wandb/terraform-kubernetes-wandb"

  license = var.license

  host                       = module.wandb_infra.url
  bucket                     = "gs://${module.wandb_infra.bucket_name}"
  bucket_queue               = "pubsub:/${module.wandb_infra.bucket_queue_name}"
  database_connection_string = "mysql://${module.wandb_infra.database_connection_string}"

  service_port = module.wandb_infra.internal_app_port

  # If we dont wait, tf will start trying to deploy while the work group is
  # still spinning up
  depends_on = [module.wandb_infra]
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = var.namespace
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = module.wandb_infra.lb_ip_name,
      "networking.gke.io/managed-certificates"      = "${var.namespace}-cert",
    }
  }

  spec {
    backend {
      service_name = "wandb"
      service_port = 8080
    }
  }
}

resource "kubernetes_manifest" "managed_certificate" {
  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "${var.namespace}-cert"
      namespace = "default"
    }

    spec = {
      domains = [module.wandb_infra.fqdn]
    }
  }
}
