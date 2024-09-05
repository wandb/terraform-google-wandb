resource "google_compute_subnetwork" "psc_network" {
  name = "${var.clickhouse_region}-subnet"

  ip_cidr_range            = "10.20.0.0/16"
  private_ip_google_access = true
  network                  = var.network.id
  region = var.clickhouse_region
}

resource "google_compute_address" "psc_endpoint_ip" {
  #  You can specify an IP address if needed.
  #  address      = "10.148.0.2"
  address_type = "INTERNAL"
  name         = "clickhouse-cloud-psc-${var.clickhouse_region}"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = google_compute_subnetwork.psc_network.self_link
  region       = var.clickhouse_region
}

resource "google_compute_forwarding_rule" "clickhouse_cloud_psc" {
  ip_address            = google_compute_address.psc_endpoint_ip.self_link
  name                  = "ch-cloud-${var.clickhouse_region}"
  network               = var.network.id
  region       = var.clickhouse_region
  load_balancing_scheme = ""
  # service attachment
  target = "https://www.googleapis.com/compute/v1/${var.clickhouse_private_endpoint_service_name}"
  allow_psc_global_access = true
}

output "psc_connection_id" {
  value       = google_compute_forwarding_rule.clickhouse_cloud_psc.psc_connection_id
  description = "Add GCP PSC Connection ID to allow list on instance level."
}

resource "google_dns_managed_zone" "clickhouse_cloud_private_service_connect" {
  description   = "Private DNS zone for accessing ClickHouse Cloud using Private Service Connect"
  dns_name      = "${var.clickhouse_region}.p.gcp.clickhouse.cloud."
  force_destroy = false
  name          = "clickhouse-cloud-private-service-connect-${var.clickhouse_region}"
  visibility    = "private"

  // associate private DNS zone with network
  private_visibility_config {
    networks {
      network_url = var.network.id
    }
  }
}

resource "google_dns_record_set" "psc-wildcard" {
  managed_zone = google_dns_managed_zone.clickhouse_cloud_private_service_connect.name
  name         = "*.${var.clickhouse_region}.p.gcp.clickhouse.cloud."
  type         = "A"
  rrdatas      = [google_compute_address.psc_endpoint_ip.address]
  ttl          = 3600
}

resource "google_compute_route" "default_to_psc" {
  name                    = "${var.namespace}-default-to-psc"
  network                 = var.network.self_link
  destination_range       = google_compute_subnetwork.psc_network.ip_cidr_range
  next_hop_ilb            = "YOUR_NEXT_HOP"
  priority                = 1000
  tags                    = ["default-to-psc"]
}
