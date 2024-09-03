resource "google_compute_address" "psc_endpoint_ip" {
  #  You can specify an IP address if needed.
  #  address      = "10.148.0.2"
  address_type = "INTERNAL"
  name         = "clickhouse-cloud-psc-${var.clickhouse_region}"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = var.subnetwork
}

resource "google_compute_forwarding_rule" "clickhouse_cloud_psc" {
  ip_address            = google_compute_address.psc_endpoint_ip.self_link
  name                  = "ch-cloud-${var.clickhouse_region}"
  network               = var.network
  region                = var.clickhouse_region
  load_balancing_scheme = ""
  # service attachment
  target = "https://www.googleapis.com/compute/v1/${var.clickhouse_private_endpoint_service_name}"
}

output "psc_connection_id" {
  value       = google_compute_forwarding_rule.clickhouse_cloud_psc.psc_connection_id
  description = "Add GCP PSC Connection ID to allow list on instance level."
}
