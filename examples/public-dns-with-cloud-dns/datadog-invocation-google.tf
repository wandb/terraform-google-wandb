variable "dd_api_key" {
  nullable = true
  type     = string
}
variable "dd_app_key" {
  nullable = true
  type     = string
}
variable "dd_site" {
  nullable = true
  type     = string
}

#  variable "k8s_cluster_ca_certificate" {
#    nullable = false
#    type     = string
#  }

#  variable "k8s_host" {
#    nullable = false
#    type     = string
#  }

#  variable "k8s_token" {
#    nullable = false
#    type     = string
#  }

data "google_container_cluster" "wandb" {
   name = module.wandb.cluster_name
}

#  module "datadog" {
#    source             = "git::https://github.com/wandb/terraform-wandb-modules.git//datadog?ref=working"

#    cloud_provider_tag = "aws"
#    cluster_name       = module.wandb.cluster_name
#    database_tag       = "managed"
#    api_key            = var.dd_api_key
#    app_key            = var.dd_app_key
#    site               = var.dd_site
#    environment_tag    = "managed-install"
#    #k8s_cluster_ca_certificate = base64decode(data.gke.wandb.k8s_cluster_ca_certificate)
#    #k8s_host                   = data.gke.wandb.k8s_host
#    #k8s_token                  = data.gke.wandb.k8s_token
#    namespace       = var.namespace
#    objectstore_tag = "managed"
# }
