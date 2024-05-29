provider "google" {}
provider "google-beta" {}

resource "random_pet" "main" {
  length    = 1
  prefix    = "tgw-pd"
  separator = "-"
}

variable "license" {
  type = string
}

locals {
  labels = {
    oktodelete  = "true"
    department  = "engineering"
    product     = "server"
    repository  = "terraform-google-wandb"
    description = "public-dns"
    environment = "test"
  }

  subdomain = "tgw-pd"
}

data "google_client_config" "current" {}

data "google_dns_managed_zone" "default" {
  project = data.google_client_config.current.project
  name    = "wandb-ml"
}

# Create A record which points to lb ip address
resource "google_dns_record_set" "a" {
  project      = data.google_client_config.current.project
  name         = "${local.subdomain}.${data.google_dns_managed_zone.default.dns_name}"
  managed_zone = data.google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 60
  rrdatas      = [module.wandb.address]
}

module "wandb" {
  source = "../../"

  namespace   = random_pet.main.id
  license     = var.license
  domain_name = "wandb.ml"
  subdomain   = local.subdomain

  create_redis       = true
  use_internal_queue = true

  deletion_protection = false

  labels = local.labels
}

output "url" {
  value = module.wandb.url
}

output "health_check_url" {
  value = "${module.wandb.url}/health"
}
