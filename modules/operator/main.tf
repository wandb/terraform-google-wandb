resource "helm_release" "operator" {
  name             = "operator"
  chart            = "operator"
  repository       = "https://charts.wandb.ai"
  version          = "0.1.5"
  namespace        = "wandb"
  create_namespace = true
  wait             = true

  set {
    name  = "image.tag"
    value = "1.2.12"
  }
}

locals {
  spec = yamlencode({
    release = {
      url = "https://github.com/wandb/cdk8s"
    }
    config = {
      bucket = { connectionString = var.bucket }
      mysql  = var.database
      redis  = var.redis

      ingress = {
        metadata = {
          annotations = {
            "kubernetes.io/ingress.global-static-ip-name" : var.address_name
            "networking.gke.io/managed-certificates" : "wandb-cert"
            "kubernetes.io/ingress.allow-http" : "false"
          }
        }
      }
    }
  })
}

resource "helm_release" "instance" {
  name       = "wandb"
  chart      = "operator"
  repository = path.module

  namespace        = "default"
  create_namespace = true
  wait             = true

  set {
    name  = "domain"
    value = var.fqdn
  }

  set {
    name  = "cloud"
    value = "google"
  }

  set {
    name  = "spec"
    value = local.spec
    type  = "string"
  }

  depends_on = [helm_release.operator]
}