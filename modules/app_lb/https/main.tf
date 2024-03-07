# Configure an HTTPS proxy with the Google-managed certificate and route it to
# the URL map
resource "google_compute_target_https_proxy" "default" {
  name             = "${var.namespace}-https-proxy"
  url_map          = var.url_map.id
  ssl_certificates = [var.certificate_id]
  ssl_policy       = google_compute_ssl_policy.default.id
}

# Configure a global forwarding rule to route the HTTPS traffic on the IP
# address to the target HTTPS proxy:
resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.namespace}-https"
  target     = var.certificate_id
  port_range = "443"
  ip_address = var.ip_address
  labels     = var.labels
}

# SSL Policy to apply to Target Https Proxy
resource "google_compute_ssl_policy" "default" {
  name            = "${var.namespace}-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"

  lifecycle {
    create_before_destroy = true
  }
}
