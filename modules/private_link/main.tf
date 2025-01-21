data "google_client_config" "current" {}

# proxy-only subnet used by internal load balancer
resource "google_compute_subnetwork" "proxy" {
  name          = "${var.namespace}-proxy-subnet"
  ip_cidr_range = var.proxynetwork_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = var.network.id
  timeouts {
    delete = "2m"
  }
}

resource "google_compute_region_network_endpoint_group" "external_lb" {
  name   = "${var.namespace}-psc-lb-neg"
  region = data.google_client_config.current.region

  network_endpoint_type = "INTERNET_FQDN_PORT"
  network               = var.network.self_link
}

resource "google_compute_region_network_endpoint" "external_lb" {
  region_network_endpoint_group = google_compute_region_network_endpoint_group.external_lb.name

  fqdn = var.fqdn
  port = 443
}

resource "google_compute_region_backend_service" "internal_nlb" {
  name                  = "${var.namespace}-psc-nlb"
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group          = google_compute_region_network_endpoint_group.external_lb.id
    balancing_mode = "UTILIZATION"
  }
}

resource "google_compute_region_target_tcp_proxy" "internal_nlb" {
  name            = "${var.namespace}-psc-nlb"
  backend_service = google_compute_region_backend_service.internal_nlb.id
}

resource "google_compute_forwarding_rule" "internal_nlb" {
  name                  = "${var.namespace}-psc-nlb"
  load_balancing_scheme = "INTERNAL_MANAGED"

  allow_global_access = true
  ip_protocol         = "TCP"
  port_range          = "443"

  target = google_compute_region_target_tcp_proxy.internal_nlb.id

  network    = var.network.id
  subnetwork = var.subnetwork.self_link

  depends_on = [google_compute_subnetwork.proxy]
}

resource "google_compute_service_attachment" "default" {
  name                  = "${var.namespace}-private-link"
  connection_preference = "ACCEPT_MANUAL"
  enable_proxy_protocol = false
  nat_subnets           = [google_compute_subnetwork.default.id]
  target_service        = google_compute_forwarding_rule.internal_nlb.self_link

  dynamic "consumer_accept_lists" {
    for_each = var.allowed_project_names != {} ? var.allowed_project_names : {}
    content {
      project_id_or_num = consumer_accept_lists.key
      connection_limit  = consumer_accept_lists.value
    }
  }
  depends_on = [
    google_compute_subnetwork.default
  ]
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.namespace}-psc-ilb-subnet"
  network       = var.network.id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range = var.psc_subnetwork
}


# allow all access from IAP and health check ranges
resource "google_compute_firewall" "default" {
  name          = "${var.namespace}-internal-fw"
  provider      = google-beta
  direction     = "INGRESS"
  network       = var.network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20", var.proxynetwork_cidr]
  allow {
    protocol = "tcp"
  }
}
