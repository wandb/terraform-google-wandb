data "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = var.ingress_name
  }
}

locals {
  lb_name = data.kubernetes_ingress_v1.ingress.metadata[0].annotations != null ? data.kubernetes_ingress_v1.ingress.metadata[0].annotations["ingress.kubernetes.io/forwarding-rule"] : ""
}

resource "google_compute_service_attachment" "psc_ilb_service_attachment" {
  name                  = "${var.namespace}-private-link"
  enable_proxy_protocol = false
  connection_preference = "ACCEPT_MANUAL"
  nat_subnets           = [google_compute_subnetwork.psc_ilb_nat.id]
  target_service        =  local.lb_name

 dynamic "consumer_accept_lists" {
    for_each = var.allowed_projects != {} ? var.allowed_projects : {}
    content {
      project_id_or_num = consumer_accept_lists.key
      connection_limit  = consumer_accept_lists.value
    }
  }
  depends_on = [ data.kubernetes_ingress_v1.ingress ]
}

resource "google_compute_subnetwork" "psc_ilb_nat" {
  name          = "${var.namespace}-psc-ilb-subnet"
  network       = var.network.id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range = var.psc_subnetwork
}

# proxy-only subnet
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = "${var.namespace}-proxy-subnet"
  provider      = google-beta
  ip_cidr_range = var.proxynetwork_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = var.network.id
}
# allow all access from IAP and health check ranges
resource "google_compute_firewall" "fw_iap" {
  name          = "${var.namespace}-internal-fw"
  provider      = google-beta
  direction     = "INGRESS"
  network       = var.network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20"]
  allow {
    protocol = "tcp"
  }
}

# allow tcp from proxy subnet to backends
resource "google_compute_firewall" "fw_iap_rule" {
  name          = "${var.namespace}-fw-allow-iap-hc"
  provider      = google-beta
  direction     = "INGRESS"
  network       = var.network.id
  source_ranges = [var.proxynetwork_cidr]
  allow {
    protocol = "tcp"
  }
}