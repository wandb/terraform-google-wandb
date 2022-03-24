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
# # want to update your DNS with the provisioned API
# module "certificate" {
#   depends_on = [module.wandb_infra]
#   source     = "../../modules/certificate"

#   namespace = var.namespace
#   fqdn      = module.wandb_infra.fqdn
# }

output "url" {
  value = module.wandb_infra.url
}

# output "ip_address" {
#   value = module.certificate.ip_address
# }

output "address" {
  value = module.wandb_infra.address
}