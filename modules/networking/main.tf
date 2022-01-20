resource "google_compute_network" "vpc" {
  name        = "${var.namespace}-vpc"
  description = "Weights & Biases VPC Network"
}

# resource "google_compute_global_address" "private_ip_address" {
#   name          = "${var.namespace}-private-ip-address"
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = 20
#   network       = google_compute_network.vpc.self_link
# }

# resource "google_service_networking_connection" "private_vpc_connection" {
#   network = google_compute_network.vpc.self_link
#   service = "servicenetworking.googleapis.com"

#   reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
# }