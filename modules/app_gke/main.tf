data "google_client_config" "current" {}

locals {
  project_id = data.google_client_config.current.project
}

resource "google_container_cluster" "default" {
  name            = "${var.namespace}-cluster"
  resource_labels = var.labels

  network                     = var.network.self_link
  subnetwork                  = var.subnetwork.self_link
  networking_mode             = "VPC_NATIVE"
  enable_intranode_visibility = true
  deletion_protection         = var.deletion_protection

  dynamic "addons_config" {
    for_each = var.enable_gcs_fuse_csi_driver == true ? [1] : []
    content {
      gcs_fuse_csi_driver_config {
        enabled = true
      }
    }
  }

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
    channel = var.release_channel
  }

  min_master_version = var.gke_min_version

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
  lifecycle {
    ignore_changes = [keepers]
  }
}

resource "google_container_node_pool" "default" {
  name    = "default-pool-${random_pet.node_pool.id}"
  cluster = google_container_cluster.default.id

  autoscaling {
    total_max_node_count = var.max_node_count
    total_min_node_count = var.min_node_count
    location_policy      = "BALANCED"
  }

  network_config {
    enable_private_nodes = var.enable_private_gke_nodes
  }

  node_config {
    image_type      = "COS_CONTAINERD"
    disk_size_gb    = var.disk_size_gb
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

    workload_metadata_config {
      mode = var.create_workload_identity ? "GKE_METADATA" : "GCE_METADATA"
    }
    shielded_instance_config {
      enable_secure_boot = true
    }

    kubelet_config {
      cpu_manager_policy = "none"
      cpu_cfs_quota      = true
      pod_pids_limit     = 0
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = var.labels
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
