# create cloud router for nat gateway
resource "google_compute_router" "this" {
  name    = "${var.namespace}-cloud-router"
  network = var.network.self_link
}

resource "google_compute_address" "this" {
  name   = "${var.namespace}-cloud-nat-ip"
  region = google_compute_router.this.region

  labels = var.labels

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_address" "nat_lb_proxy_address" {
  count  = var.proxy_nat ? 1 : 0
  name   = "${var.namespace}-cloud-nat-lb-proxy-ip"
  region = google_compute_router.this.region

  labels = var.labels

  lifecycle {
    create_before_destroy = true
  }
}

# create cloud nat public gateway
resource "google_compute_router_nat" "nat" {
  count                              = var.vpc_nat ? 1 : 0
  name                               = "${var.namespace}-cloud-nat"
  router                             = google_compute_router.this.name
  region                             = google_compute_router.this.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.this.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# create cloud nat public gateway for Private Service Connect LB
resource "google_compute_router_nat" "nat_lb_proxy" {
  count                              = var.proxy_nat ? 1 : 0
  name                               = "${var.namespace}-cloud-nat-lb-proxy"
  router                             = google_compute_router.this.name
  region                             = google_compute_router.this.region
  enable_dynamic_port_allocation     = var.proxy_nat_enable_dynamic_port_allocation
  min_ports_per_vm                   = var.proxy_nat_min_ports_per_vm
  max_ports_per_vm                   = var.proxy_nat_max_ports_per_vm
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_lb_proxy_address[0].*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  endpoint_types                     = ["ENDPOINT_TYPE_MANAGED_PROXY_LB"]
}
