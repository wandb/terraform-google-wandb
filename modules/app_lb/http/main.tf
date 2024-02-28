resource "google_compute_target_http_proxy" "default" {
  name    = "${var.namespace}-http-proxy"
  url_map = var.url_map.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name = "${var.namespace}-http"

  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = var.ip_address

  labels = var.labels
}
