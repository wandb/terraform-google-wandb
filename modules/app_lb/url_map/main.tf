locals {
  port_name = "${var.namespace}-local-port"
}

resource "google_compute_instance_group_named_port" "default" {
  group = var.group
  name  = local.port_name
  port  = var.target_port
}

resource "google_compute_health_check" "gke_ingress" {
  name = "${var.namespace}-hc-gke-ingress"

  http_health_check {
    port         = var.target_port
    request_path = "/ready"
  }

  log_config {
    enable = true
  }
}

# This is an ingress rule that allows traffic from the Google Cloud health
# checking systems (130.211.0.0/22 and 35.191.0.0/16).
# https://cloud.google.com/load-balancing/docs/https/ext-https-lb-simple#firewall
resource "google_compute_firewall" "hc" {
  name          = "${var.namespace}-hc"
  network       = var.network.self_link
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  direction     = "INGRESS"
  priority      = 5

  allow {
    protocol = "tcp"
    ports    = [var.target_port]
  }
}


resource "google_compute_security_policy" "default" {
  name = var.namespace

  rule {
    action   = "deny(403)"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Deny access to all IPs"
  }

  rule {
    action   = "allow"
    priority = 1
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.allowed_inbound_cidrs
      }
    }
    description = "allow list rule"
  }
}

resource "google_compute_backend_service" "default" {
  name            = "${var.namespace}-gke-ingress"
  timeout_sec     = 90
  protocol        = "HTTP"
  enable_cdn      = false
  port_name       = local.port_name
  security_policy = google_compute_security_policy.default.id

  log_config {
    enable      = true
    sample_rate = 1.0
  }

  backend {
    # https://github.com/hashicorp/terraform/issues/4336
    group = replace(var.group, "Manager", "")
  }

  health_checks = [google_compute_health_check.gke_ingress.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "default" {
  name            = "${var.namespace}-urlmap"
  default_service = google_compute_backend_service.default.self_link

  lifecycle {
    create_before_destroy = true
  }
}
