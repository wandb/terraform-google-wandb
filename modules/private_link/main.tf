data "google_client_config" "current" {}

# proxy-only subnet used by internal load balancer
resource "google_compute_subnetwork" "proxy" {
  name          = "${var.namespace}-proxy-subnet"
  ip_cidr_range = var.ilb_proxynetwork_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = var.network.id
  timeouts {
    delete = "2m"
  }
}

data "google_compute_forwarding_rules" "all" {
  depends_on = [google_compute_subnetwork.proxy]
}

locals {
  filtered_rule_names = [
    for rule in data.google_compute_forwarding_rules.all.rules :
    rule.name if can(regex(var.ilb_name, rule.name))
  ]
  forwarding_rule = join(", ", local.filtered_rule_names)
}

resource "google_compute_service_attachment" "default" {
  name                  = "${var.namespace}-private-link"
  enable_proxy_protocol = false
  connection_preference = "ACCEPT_MANUAL"
  nat_subnets           = [google_compute_subnetwork.default.id]
  target_service        = "https://www.googleapis.com/compute/v1/projects/${data.google_client_config.current.project}/regions/${data.google_client_config.current.region}/forwardingRules/${local.forwarding_rule}"

  dynamic "consumer_accept_lists" {
    for_each = var.allowed_project_names != {} ? var.allowed_project_names : {}
    content {
      project_id_or_num = consumer_accept_lists.key
      connection_limit  = consumer_accept_lists.value
    }
  }
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.namespace}-psc-ilb-subnet"
  network       = var.network.id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range = var.psc_subnetwork_cidr
}


# allow all access from IAP and health check ranges
resource "google_compute_firewall" "default" {
  name          = "${var.namespace}-internal-fw"
  provider      = google-beta
  direction     = "INGRESS"
  network       = var.network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20", var.ilb_proxynetwork_cidr]
  allow {
    protocol = "tcp"
  }
}
