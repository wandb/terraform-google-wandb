resource "google_compute_global_address" "default" {
  count = var.internal_lb ? 1 : 0
  name  = "${var.namespace}-address"
}

# Create a URL map that points to the GKE service
module "url_map" {
  source                = "./url_map"
  namespace             = var.namespace
  group                 = var.group
  target_port           = var.target_port
  network               = var.network
  internal_lb           = var.internal_lb
  ip_address            = var.internal_lb ? var.internal_ip : google_compute_global_address.default.address
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
}

module "http" {
  count = !var.ssl && var.internal_lb ? 1 : 0

  source      = "./http"
  namespace   = var.namespace
  internal_lb = var.internal_lb
  url_map     = var.internal_lb ? module.url_map.internal : module.url_map.app
  ip_address  = var.internal_lb ? var.internal_ip : google_compute_global_address.default.address

  labels = var.labels
}

module "https" {
  count = var.ssl && !var.internal_lb ? 1 : 0

  source      = "./https"
  fqdn        = var.fqdn
  namespace   = var.namespace
  url_map     = module.url_map.app
  internal_lb = var.internal_lb
  ip_address  = google_compute_global_address.default.address

  labels = var.labels
}
