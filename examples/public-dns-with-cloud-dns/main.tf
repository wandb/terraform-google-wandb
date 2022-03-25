provider "google" {
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

  namespace = var.namespace
  license = var.license
  domain_name = var.domain
  subdomain   = var.subdomain

  deletion_protection = false
}

# You'll want to update your DNS with the provisioned IP address

output "url" {
  value = module.wandb.url
}

output "address" {
  value = module.wandb.address
}