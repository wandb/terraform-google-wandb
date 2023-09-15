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
  address_type  = "INTERNAL"
  # TODO: upgrade to provider which supports labels
  #labels        = var.labels
  name          = "${var.namespace}-private-ip-address"
  network       = google_compute_network.vpc.id
  prefix_length = 16
  purpose       = "VPC_PEERING"
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
