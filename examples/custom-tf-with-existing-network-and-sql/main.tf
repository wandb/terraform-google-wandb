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

data "google_compute_network" "network" {
  name = var.network
}

data "google_compute_subnetwork" "subnetwork" {
  name = var.subnetwork
}


# Spin up all required services
module "wandb" {
  source                = "../../"
  namespace             = var.namespace
  license               = var.license
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
  domain_name           = var.domain_name
  subdomain             = var.subdomain
  gke_machine_type      = var.gke_machine_type
  gke_node_count        = var.gke_node_count
  wandb_version         = var.wandb_version
  wandb_image           = var.wandb_image
  disable_code_saving   = var.disable_code_saving
  size                  = var.size
  labels                = var.labels
  create_redis          = var.create_redis
  local_restore         = false
  use_internal_queue    = true
  force_ssl             = false
  deletion_protection   = false
  network               = var.network
  network_link          = data.google_compute_network.network.self_link
  subnetwork            = data.google_compute_subnetwork.subnetwork.id
  create_database       = var.create_database
  database_env          = var.database_env
}

output "url" {
  value = module.wandb.url
}

output "address" {
  value = module.wandb.address
}

output "bucket_name" {
  value = module.wandb.bucket_name
}

output "standardized_size" {
  value = var.size
}

output "gke_node_count" {
  value = module.wandb.gke_node_count
}

output "gke_node_instance_type" {
  value = module.wandb.gke_node_instance_type
}