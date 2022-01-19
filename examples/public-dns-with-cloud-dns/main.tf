provider "google" {
  project = var.project_id
  region  = "us-central1"
}

module "wandb_infra" {
  source = "../../"

  namespace     = var.namespace

  domain_name = var.domain
  subdomain   = var.subdomain
}
