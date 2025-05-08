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

data "clickhouse_api_key_id" "self" {
}

resource "clickhouse_service" "service" {
  count = (var.clickhouse_provision_service && var.clickhouse_provision_service) ? 1 : 0

  name           = var.clickhouse_service_name
  cloud_provider = "gcp"
  region         = var.clickhouse_region

  ip_access = [
    {
      source      = "34.75.179.217" # TODO: do not hardcode
      description = "Dagster / Analytics"
    }
  ]

  # Required in order to create 'clickhouse_user', 'clickhouse_role' and 'clickhouse_grant*' resources below.
  #query_api_endpoints = {
  #  api_key_ids = [
  #    data.clickhouse_api_key_id.self.id,
  #  ]
  #  roles = [
  #    "sql_console_admin"
  #  ]
  #  allowed_origins = null
  #}

  min_replica_memory_gb  = 16
  max_replica_memory_gb  = 16
  idle_scaling           = true
  idle_timeout_minutes   = 720 # 12 hours * 60 minutes/hour

  num_replicas   = var.clickhouse_num_replicas
  password_hash  = "n4bQgYhMfWWaL+qgxVrQFaO/TxsrC4Is0V1sFbDwCgg=" # TODO: pass this in, base64 encoded sha256 hash of "test"

  transparent_data_encryption = {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      min_replica_memory_gb,
      max_replica_memory_gb,
      idle_scaling,
      idle_timeout_minutes,
    ]
  }
}

#resource "clickhouse_service_private_endpoints_attachment" "attachment" {
#  private_endpoint_ids = [
#    clickhouse_private_endpoint_registration.endpoint.id
#  ]
#  service_id = clickhouse_service.svc.id
#}

# ---

#resource "aws_vpc_endpoint" "pl_vpc_foo" {
#  vpc_id            = aws_vpc.vpc.id
#  service_name      = clickhouse_service.svc1.endpoint_config.endpoint_service_id
#  ...
#}

#resource "clickhouse_service_private_endpoints_attachment" "red_attachment" {
#  private_endpoint_ids = [aws_vpc_endpoint.pl_vpc_foo.id]
#  service_id = clickhouse_service.aws_red.id
#}

resource "clickhouse_service_private_endpoints_attachment" "service_attachment" {
  private_endpoint_ids = [google_compute_forwarding_rule.psc_forward_rule.psc_connection_id]
  service_id = clickhouse_service.service[0].id
}

#
# Requires 'query_api_endpoints' to be enabled in the service.
#resource "clickhouse_user" "john" {
#  service_id           = clickhouse_service.service[0].id
#  name                 = "john"
#  password_sha256_hash = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08" # sha256 of 'test'
#}

## Requires 'query_api_endpoints' to be enabled in the service.
#resource "clickhouse_role" "writer" {
#  service_id           = clickhouse_service.service.id
#  name                 = "writer"
#}

# Requires 'query_api_endpoints' to be enabled in the service.
#resource "clickhouse_grant_role" "writer_to_john" {
#  service_id        = clickhouse_service.service[0].id
#  role_name         = clickhouse_role.writer.name
#  grantee_user_name = clickhouse_user.john.name
#  admin_option      = false
#}
