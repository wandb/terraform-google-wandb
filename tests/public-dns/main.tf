provider "google" {
  default_labels = local.labels
}

provider "google-beta" {
  default_labels = local.labels
}

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
}

module "wandb" {
  source = "../../"

  namespace   = random_pet.main.id
  subdomain   = random_pet.main.id
  license     = var.license
  domain_name = "wandb.ml"

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
