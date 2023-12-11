data "google_compute_zones" "available" {
}

resource "google_redis_instance" "default" {
  name           = "${var.namespace}-redis"
  display_name   = "${var.namespace} W&B Instance"
  tier           = "STANDARD_HA"
  memory_size_gb = var.memory_size_gb

  location_id             = data.google_compute_zones.available.names.0
  alternative_location_id = data.google_compute_zones.available.names.1

  authorized_network = var.network.id

  redis_version     = "REDIS_6_X"
  reserved_ip_range = var.reserved_ip_range

  transit_encryption_mode = "SERVER_AUTHENTICATION"
  connect_mode            = "DIRECT_PEERING"

  auth_enabled = true

  labels = var.labels
}
