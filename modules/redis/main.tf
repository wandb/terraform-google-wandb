data "google_compute_zones" "available" {
}

resource "google_redis_instance" "default" {
  name                 = "${var.namespace}-redis"
  display_name         = "${var.namespace} W&B Instance"
  tier                 = var.tier
  memory_size_gb       = var.memory_size_gb
  customer_managed_key = var.crypto_key

  location_id             = data.google_compute_zones.available.names.0
  alternative_location_id = data.google_compute_zones.available.names.1

  authorized_network = var.network.id

  redis_version     = "REDIS_6_X"
  reserved_ip_range = var.reserved_ip_range

  transit_encryption_mode = "SERVER_AUTHENTICATION"
  connect_mode            = "DIRECT_PEERING"

  auth_enabled = true

  labels = var.labels

  redis_configs = {
    notify-keyspace-events = "K$"
  }

  lifecycle {
    ignore_changes = [
      location_id,
      alternative_location_id
    ]
  }
}
