resource "google_compute_global_address" "default" {
  name = "${var.namespace}-address"
}

resource "google_compute_global_address" "operator" {
  name = "${var.namespace}-operator-address"
}

module "https" {
  count = var.ssl ? 1 : 0

  source     = "./https"
  fqdn       = var.fqdn
  namespace  = var.namespace
  url_map    = module.url_map.app
  ip_address = google_compute_global_address.default.address

  labels = var.labels
}
