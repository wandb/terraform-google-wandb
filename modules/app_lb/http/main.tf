resource "google_compute_target_http_proxy" "default" {
  count   = var.internal_lb ? 0 : 1
  name    = "${var.namespace}-http-proxy"
  url_map = var.url_map.id
}

resource "google_compute_target_http_proxy" "internal" {
  count   = var.internal_lb ? 1 : 0
  name    = "${var.namespace}-http-proxy"
  url_map = var.url_map.id
}


resource "google_compute_global_forwarding_rule" "default" {
  name = "${var.namespace}-http"

  target     = google_compute_target_http_proxy.default[0].id
  port_range = "80"
  ip_address = var.ip_address

  labels = var.labels
}


resource "google_compute_global_forwarding_rule" "internal" {
  name = "${var.namespace}-http"

  target     = google_compute_target_http_proxy.internal[0].id
  port_range = "80"
  ip_address = var.ip_address

  labels = var.labels
}
