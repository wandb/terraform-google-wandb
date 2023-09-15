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

# Spin up all required services
module "wandb" {
  source = "../../"

  allowed_inbound_cidrs     = var.allowed_inbound_cidrs
  create_redis              = false
  database_machine_type     = var.database_machine_type
  database_sort_buffer_size = var.database_sort_buffer_size
  deletion_protection       = false
  disable_code_saving       = var.disable_code_saving
  domain_name               = var.domain_name
  force_ssl                 = var.force_ssl
  gke_machine_type          = var.gke_machine_type
  labels                    = var.labels
  license                   = var.license
  namespace                 = var.namespace
  subdomain                 = var.subdomain
  use_internal_queue        = true
  wandb_image               = var.wandb_image
  wandb_version             = var.wandb_version
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
