resource "google_compute_global_address" "operator" {
  name = "${var.namespace}-operator-address"
}

module "https" {
  count = var.ssl ? 1 : 0

  source    = "./https"
  fqdn      = var.fqdn
  namespace = var.namespace

  labels = var.labels
}
