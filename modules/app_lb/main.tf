resource "google_compute_global_address" "default" {
  name = "${var.namespace}-address"
}

resource "google_compute_global_address" "operator" {
  name = "${var.namespace}-operator-address"
}

# Create a URL map that points to the GKE service
module "url_map" {
  count = var.enable_operator ? 0 : 1

  source                = "./url_map"
  namespace             = var.namespace
  group                 = var.group
  target_port           = var.target_port
  network               = var.network
  ip_address            = google_compute_global_address.default.address
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
}

module "http" {
  count = var.enable_operator ? 0 : var.ssl ? 0 : 1

  source     = "./http"
  namespace  = var.namespace
  url_map    = var.enable_operator ? { id = "" } : module.url_map.app
  ip_address = google_compute_global_address.default.address

  labels = var.labels
}

module "https" {
  count = var.enable_operator ? 0 : var.ssl ? 1 : 0

  source     = "./https"
  fqdn       = var.fqdn
  namespace  = var.namespace
  url_map    = var.enable_operator ? { id = "" } : module.url_map.app
  ip_address = google_compute_global_address.default.address

  labels = var.labels
}
