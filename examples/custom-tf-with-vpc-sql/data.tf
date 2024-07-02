data "google_compute_network" "network" {
  name = var.network
}


data "google_compute_subnetwork" "subnetwork" {
  name = var.subnetwork
}