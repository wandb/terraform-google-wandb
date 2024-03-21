resource "google_compute_service_attachment" "psc_ilb_service_attachment" {
  name        = "my-psc-ilb-${var.namespace}"
  region      = var.region
  enable_proxy_protocol    = true
  connection_preference    = "ACCEPT_MANUAL"
  nat_subnets              = [google_compute_subnetwork.psc_ilb_nat.id]
  target_service           = google_compute_forwarding_rule.psc_ilb_target_service.id
}

resource "google_compute_address" "psc_ilb_consumer_address" {
  name   = "psc-ilb-consumer-address-${var.namespace}"
  region = var.region
  subnetwork   = "default"
  address_type = "INTERNAL"
}

resource "google_compute_forwarding_rule" "psc_ilb_target_service" {
  name   = "producer-forwarding-rule-${var.namespace}"
  region = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.producer_service_backend.id
  all_ports             = true
  network               = var.network.id
  subnetwork            = var.subnetwork.self_link
}

resource "google_compute_region_backend_service" "producer_service_backend" {
  name   = "producer-service-${var.namespace}"
  region = var.region
  health_checks = [google_compute_health_check.producer_service_health_check.id]
  backend {
    balancing_mode               = "CONNECTION" 
    capacity_scaler              = 0 
    failover                     = false 
    group                        = var.instance_group 
  }
}

resource "google_compute_health_check" "producer_service_health_check" {
  name = "producer-service-health-check-${var.namespace}"
  check_interval_sec = 30
  timeout_sec        = 30
   https_health_check {
    port         = 443
    proxy_header = "NONE" 
    request_path = "/healthz" 
    response     = "200-399" 
  }
}

resource "google_compute_subnetwork" "psc_ilb_nat" {
  name   = "psc-ilb-nat-${var.namespace}"
  region = var.region
  network       = var.network.id
  purpose       =  "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range =  "10.100.0.0/24"
}
