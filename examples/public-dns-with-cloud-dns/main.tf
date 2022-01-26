provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_global_address" "ip" {
  name = "${var.namespace}-global-address"
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

  # wandb_image   = "wandb/local-dev"
  # wandb_version = "cloudsql"

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

// static ip
// 

locals {
  app_name = "wandb"
}

output "license" {
  value = var.license
}

output "service_account_email" {
  value = module.wandb_infra.service_account.email
}

output "database_connection_string" {
  value = nonsensitive(module.wandb_infra.database_connection_string)
}

output "bucket_name" {
  value = module.wandb_infra.bucket_name
}

output "bucket_queue_name" {
  value = module.wandb_infra.bucket_queue_name
}
