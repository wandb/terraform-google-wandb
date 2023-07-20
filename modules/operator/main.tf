resource "helm_release" "operator" {
  name             = "operator"
  chart            = "operator"
  repository       = "https://charts.wandb.ai"
  version          = "0.1.4"
  namespace        = "wandb"
  create_namespace = true
  wait             = true

  set {
    name  = "image.tag"
    value = "1.2.6"
  }
}

resource "kubernetes_manifest" "certificate" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"
    metadata = {
      name      = "managed-cert"
      namespace = "default"
    }
    spec = {
      domains = [var.fqdn]
    }
  }
}

resource "kubernetes_manifest" "instance" {
  manifest = {
    apiVersion = "apps.wandb.com/v1"
    kind       = "WeightsAndBiases"

    metadata = {
      name      = "wandb"
      namespace = "default"
      labels = {
        "app.kubernetes.io/name"     = "weightsandbiases"
        "app.kubernetes.io/instance" = "wandb"
      }
    }

    spec = {
      version = "https://github.com/wandb/cdk8s"

      config = {
        bucket = { connectionString = var.bucket }

        ingress = {
          metadata = {
            annotations = {
              "kubernetes.io/ingress.global-static-ip-name" : var.address_name
              "networking.gke.io/managed-certificates" : "managed-cert"
              "kubernetes.io/ingress.allow-http": "false",
            }
          }
        }
      }
    }
  }

  computed_fields = [
    "metadata.annotations",
    "metadata.labels",
  ]

  wait {
    fields = {
      "status.phase" = "Completed",
    }
  }

  depends_on = [helm_release.operator, kubernetes_manifest.certificate]
}