resource "google_container_cluster" "default" {
  name = "${var.namespace}-cluster"

  network    = var.network.self_link
  subnetwork = var.subnetwork.self_link

  release_channel {
    channel = "STABLE"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "default" {
  name       = "default-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.default.id
  node_count = 1

  node_config {
    machine_type    = "n2-standard-4"
    service_account = var.service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/bigtable.admin",
      "https://www.googleapis.com/auth/bigtable.data",
      "https://www.googleapis.com/auth/bigquery",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/sqlservice.admin",
    ]
  }

  lifecycle {
    ignore_changes = [
      # GCP will select a zone within the region automically e.g "us-central1-c"
      # -> "us-central1" this causes the pool to be destory on each apply
      location,
    ]
  }
}