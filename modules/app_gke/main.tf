data "google_client_config" "current" {}

locals {
  project_id = data.google_client_config.current.project
}

resource "google_container_cluster" "default" {
  name = "${var.namespace}-cluster"

  network                     = var.network.self_link
  subnetwork                  = var.subnetwork.self_link
  networking_mode             = "VPC_NATIVE"
  enable_intranode_visibility = true


  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  # Conditionally enable workload identity
  dynamic "workload_identity_config" {
    for_each = var.create_workload_identity == true ? [1] : []
    content {
      workload_pool = "${local.project_id}.svc.id.goog"
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/19"
  }

  release_channel {
    channel = "STABLE"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Disable client certificate authentication, which reduces the attack surface 
  # for the cluster by disabling this deprecated feature. It defaults to false, 
  # but this will make it explicit and quiet some security tooling.
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "random_pet" "node_pool" {
  keepers = {
    machine_type = var.machine_type
  }
}

resource "google_container_node_pool" "default" {
  name       = "default-pool-${random_pet.node_pool.id}"
  cluster    = google_container_cluster.default.id
  node_count = var.node_count

  node_config {
    image_type      = "COS_CONTAINERD"
    machine_type    = var.machine_type
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

     dynamic "workload_metadata_config" {
       for_each = var.create_workload_identity == true ? [1] : []
        content {
          mode = "GKE_METADATA"
        }
      }
    
    shielded_instance_config {
      enable_secure_boot = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  lifecycle {
    ignore_changes = [
      # GCP will select a zone within the region automically e.g "us-central1-c"
      # -> "us-central1" this causes the pool to be destory on each apply
      location,
    ]
    create_before_destroy = true
  }
}
