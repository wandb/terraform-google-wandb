provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}


data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${module.wandb.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.wandb.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.wandb.cluster_endpoint}"
    cluster_ca_certificate = base64decode(module.wandb.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

# Spin up all required services
module "wandb" {
  source = "../../"

  allowed_inbound_cidrs = var.allowed_inbound_cidrs
  namespace             = var.namespace
  license               = var.license
  domain_name           = var.domain_name
  subdomain             = var.subdomain

  gke_machine_type  = var.gke_machine_type
  resource_limits   = var.resource_limits
  resource_requests = var.resource_requests
  wandb_version     = var.wandb_version
  wandb_image       = var.wandb_image

  create_redis       = var.create_redis
  use_internal_queue = true
  force_ssl          = var.force_ssl

  deletion_protection = false

  database_sort_buffer_size = var.database_sort_buffer_size
  database_machine_type     = var.database_machine_type
  database_version          = var.database_version

  disable_code_saving = var.disable_code_saving
  size                = var.size
  labels              = var.labels



}


