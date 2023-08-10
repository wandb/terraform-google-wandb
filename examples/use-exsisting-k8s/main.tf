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

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location
  project  = var.project_id
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}



# Spin up all required services
module "wandb" {
  source = "../../"

  namespace   = var.namespace
  license     = var.license
  domain_name = var.domain_name
  subdomain   = var.subdomain

  gke_machine_type = var.gke_machine_type

  wandb_version = var.wandb_version
  wandb_image   = var.wandb_image

  network              = var.network
  subnetwork           = var.subnetwork
  allowed_inbound_cidr = var.allowed_inbound_cidr

  create_redis       = false
  use_internal_queue = true
  force_ssl          = var.force_ssl

  deletion_protection = false

  database_sort_buffer_size = var.database_sort_buffer_size
  database_machine_type     = var.database_machine_type

  disable_code_saving = var.disable_code_saving
}

# You'll want to update your DNS with the provisioned IP address

output "url" {
  value = module.wandb.url
}

output "address" {
  value = module.wandb.address
}

output "bucket_name" {
  value = module.wandb.bucket_name
}
