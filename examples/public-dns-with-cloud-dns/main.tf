provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "wandb_infra" {
  source = "../../"

  namespace = var.namespace

  domain_name = var.domain
  subdomain   = var.subdomain
}


# provider "kubernetes" {
#   host                   = "https://${module.wandb_infra.cluster_endpoint}"
#   cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
#   token                  = data.google_client_config.current.access_token
# }

# module "wandb_app" {
#   source = "github.com/wandb/terraform-kubernetes-wandb"

#   license = var.wandb_license

#   host                       = module.wandb_infra.url
#   bucket                     = "s3://${module.wandb_infra.bucket_name}"
#   bucket_aws_region          = module.wandb_infra.bucket_region
#   bucket_queue               = "sqs://${module.wandb_infra.bucket_queue_name}"
#   bucket_kms_key_arn         = module.wandb_infra.kms_key_arn
#   database_connection_string = "mysql://${module.wandb_infra.database_connection_string}"

#   service_port = module.wandb_infra.internal_app_port

#   # If we dont wait, tf will start trying to deploy while the work group is
#   # still spinning up
#   depends_on = [module.wandb_infra]
# }
