resource "google_compute_subnetwork" "psc_network" {
  name = "${var.namespace}-subnet-clickhouse"

  region                   = var.clickhouse_region
  ip_cidr_range            = var.clickhouse_reserved_ip_range
  private_ip_google_access = true
  network                  = var.network
}

resource "google_compute_address" "psc_endpoint_ip" {
  name         = "${var.namespace}-clickhouse-psc-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = google_compute_subnetwork.psc_network.self_link
  region       = var.clickhouse_region

  labels = var.labels
}

resource "google_compute_forwarding_rule" "psc_forward_rule" {
  name                    = "${var.namespace}-clickhouse-psc-forward"
  ip_address              = google_compute_address.psc_endpoint_ip.self_link
  network                 = var.network
  region                  = var.clickhouse_region
  load_balancing_scheme   = ""
  allow_psc_global_access = true

  labels = var.labels

  target = "https://www.googleapis.com/compute/v1/${var.clickhouse_private_endpoint_service_name}"
}

resource "google_dns_managed_zone" "psc_dns_zone" {
  name          = "${var.namespace}-clickhouse-dns-zone"
  description   = "Private DNS zone for accessing ClickHouse Cloud using Private Service Connect"
  dns_name      = "${var.clickhouse_region}.p.gcp.clickhouse.cloud."
  force_destroy = true
  visibility    = "private"

  // associate private DNS zone with network
  private_visibility_config {
    networks {
      network_url = var.network
    }
  }

  labels = var.labels
}

resource "google_dns_record_set" "psc_dns_record" {
  name         = "*.${var.clickhouse_region}.p.gcp.clickhouse.cloud."
  managed_zone = google_dns_managed_zone.psc_dns_zone.name
  type         = "A"
  rrdatas      = [google_compute_address.psc_endpoint_ip.address]
  ttl          = 3600
}

resource "clickhouse_service" "service" {
  name           = "MyService"
  cloud_provider = "gcp"
  region         = var.clickhouse_region
  idle_scaling   = true

  ip_access = [
    {
      source      = "192.168.2.63"
      description = "Test IP"
    }
  ]

  min_total_memory_gb  = 24
  max_total_memory_gb  = 360
  idle_timeout_minutes = 5

  password_hash  = "n4bQgYhMfWWaL+qgxVrQFaO/TxsrC4Is0V1sFbDwCgg=" # base64 encoded sha256 hash of "test"
}
