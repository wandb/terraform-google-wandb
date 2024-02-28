resource "random_pet" "cert" {
  length = 2
  keepers = {
    fqdn = var.fqdn
  }
}


# Create a managed SSL certificate that's issued and renewed by Google
resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.namespace}-cert-${random_pet.cert.id}"

  managed {
    domains = [var.fqdn]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Configure an HTTPS proxy with the Google-managed certificate and route it to
# the URL map
resource "google_compute_target_https_proxy" "default" {
  count = var.enable_operator ? 0 : 1

  name = "${var.namespace}-https-proxy"
  // url_map          = var.url_map.id
  url_map          = var.enable_operator ? "" : var.url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
  ssl_policy       = google_compute_ssl_policy.default.id
}

# Configure a global forwarding rule to route the HTTPS traffic on the IP
# address to the target HTTPS proxy:
resource "google_compute_global_forwarding_rule" "default" {
  count      = var.enable_operator ? 0 : 1
  name       = "${var.namespace}-https"
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = var.ip_address
  labels     = var.labels
}

# SSL Policy to apply to Target Https Proxy
resource "google_compute_ssl_policy" "default" {
  count           = var.enable_operator ? 0 : 1
  name            = "${var.namespace}-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"

  lifecycle {
    create_before_destroy = true
  }
}
