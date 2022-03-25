resource "google_compute_url_map" "redirect_to_https" {
  name = "${var.namespace}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

module "http" {
  source     = "../http"
  namespace  = var.namespace
  url_map    = google_compute_url_map.redirect_to_https
  ip_address = var.ip_address
}