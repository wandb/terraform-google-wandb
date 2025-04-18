data "google_client_config" "current" {}

resource "google_compute_network" "vpc" {
  name                    = "${var.namespace}-vpc"
  description             = "Weights & Biases VPC Network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name = "${var.namespace}-subnet"

  ip_cidr_range            = "10.10.0.0/16"
  private_ip_google_access = true
  network                  = google_compute_network.vpc.self_link

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.namespace}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  deletion_policy         = "ABANDON"
}

resource "google_compute_global_address" "api_psc" {
  name         = "${var.namespace}-gcp-api-psc-ip"
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = google_compute_network.vpc.id
  address      = var.google_api_psc_ipaddress
}

locals {
  # gcp name rules require this to start with a letter & be unique
  psc_fordwarding_rule_name = "a${substr(sha256("${var.namespace}gcpapi"), 0, 19)}"
}

resource "google_compute_global_forwarding_rule" "api_psc" {
  name                  = local.psc_fordwarding_rule_name
  ip_address            = google_compute_global_address.api_psc.self_link
  load_balancing_scheme = ""
  network               = google_compute_network.vpc.id
  target                = "all-apis"
}

resource "google_dns_managed_zone" "api_psc" {
  count       = length(var.google_api_dns_overrides)
  name        = "${var.namespace}-${var.google_api_dns_overrides[count.index]}-gcp-api-psc"
  dns_name    = "${var.google_api_dns_overrides[count.index]}.googleapis.com."
  description = "Private DNS zone for accessing Google APIs using Private Service Connect"

  visibility = "private"

  labels = var.labels

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}

resource "google_dns_record_set" "apex" {
  count        = length(var.google_api_dns_overrides)
  name         = google_dns_managed_zone.api_psc[count.index].dns_name
  managed_zone = google_dns_managed_zone.api_psc[count.index].name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.api_psc.address]

  depends_on = [google_dns_managed_zone.api_psc]
}
