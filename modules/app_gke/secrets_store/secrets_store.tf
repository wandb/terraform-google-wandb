# Install Secrets Store CSI Driver via Helm
resource "helm_release" "secrets_store_csi_driver" {
  name       = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  version    = var.secrets_store_csi_driver_version
  namespace  = "kube-system"

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }

  set {
    name  = "enableSecretRotation"
    value = "true"
  }

  set {
    name  = "rotationPollInterval"
    value = "120s"
  }
}

# Install GCP Secrets Manager Provider for Secrets Store CSI Driver
# NOTE: GCP provider doesn't have a published Helm repository, so we fetch and apply the YAML manifest
data "http" "gcp_provider_manifest" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp/v${var.secrets_store_csi_driver_provider_gcp_version}/deploy/provider-gcp-plugin.yaml"
}

locals {
  gcp_provider_manifests = [
    for manifest in split("---", data.http.gcp_provider_manifest.response_body) :
    manifest
    if trimspace(manifest) != "" && can(yamldecode(manifest))
  ]
}

resource "kubectl_manifest" "gcp_provider" {
  for_each = { for idx, manifest in local.gcp_provider_manifests : idx => manifest }

  yaml_body = each.value

  server_side_apply = true
  wait              = true

  depends_on = [
    helm_release.secrets_store_csi_driver
  ]
}

# NOTE: The SecretProviderClass is created by the application Helm chart (operator-wandb),
# not by Terraform. This avoids CRD timing issues and keeps application-specific configuration
# with the application deployment.
