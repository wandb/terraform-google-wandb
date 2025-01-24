terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.34.0"
    }
  }
}
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
}

resource "google_compute_global_address" "psc_endpoint_ip" {
  name         = "${var.namespace}-gcp-api-psc-ip"
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = google_compute_network.vpc.id
  address      = "100.100.100.106"
}

resource "google_compute_global_forwarding_rule" "psc_forward_rule" {
  provider = google.nolabels
  name                    = "gcpapipsc"
  ip_address              = google_compute_global_address.psc_endpoint_ip.self_link
  load_balancing_scheme   = ""
  network      = google_compute_network.vpc.id
  target = "all-apis"
  labels = null
}

resource "google_dns_managed_zone" "private-zone" {
  name        = "${var.namespace}-gcp-api-psc"
  dns_name    = "googleapis.com."
  description = "Private DNS zone for accessing Google APIs using Private Service Connect"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}

resource "google_dns_record_set" "cname" {
  name         = "*.${google_dns_managed_zone.private-zone.dns_name}"
  managed_zone = google_dns_managed_zone.private-zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [google_dns_managed_zone.private-zone.dns_name]
}

resource "google_dns_record_set" "apex" {
  name         = google_dns_managed_zone.private-zone.dns_name
  managed_zone = google_dns_managed_zone.private-zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.psc_endpoint_ip.address]
}
