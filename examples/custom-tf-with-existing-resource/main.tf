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

data "google_container_cluster" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

data "google_redis_instance" "my_instance" {
  name = var.redis_cluster_name
}

module "wandb" {
  source              = "../../"
  namespace           = var.namespace
  license             = var.license
  domain_name         = var.domain_name
  subdomain           = var.subdomain
  redis_ca_cert       = data.google_redis_instance.my_instance.server_ca_certs[0].cert
  wandb_image         = var.wandb_image
  wandb_version       = var.wandb_version
  resource_limits     = var.resource_limits
  resource_requests   = var.resource_requests
  disable_code_saving = var.disable_code_saving
  redis_env           = var.redis_env
  database_env        = var.database_env
  network             = var.network
  subnetwork          = var.subnetwork
  labels              = var.labels
  create_redis        = false # must be false 
  create_gke          = false # must be false 
  create_database     = false # must be false
  self_redis          = true  # must be true
  use_internal_queue  = true
  deletion_protection = false
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