data "google_client_config" "current" {}

data "google_compute_network" "default" {
  name = var.network
}


data "google_compute_subnetwork" "default" {
  name = var.subnetwork
}

data "google_container_cluster" "default" {
  name = var.cluster_name
}

data "google_redis_instance" "default" {
  name = var.redis_cluster_name
}