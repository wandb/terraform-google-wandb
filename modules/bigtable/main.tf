locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "google_bigtable_instance" "default" {
  name = "${var.namespace}"
  deletion_protection = var.deletion_protection
  force_destroy = !var.deletion_protection

  cluster {
    cluster_id   = "${var.namespace}-c1"
    storage_type = var.storage_type
    kms_key_name = var.crypto_key
    autoscaling_config {
      min_nodes = 1
      max_nodes = 3
      cpu_target = 70
    }
  }

  labels = var.labels
}

resource "google_bigtable_instance_iam_member" "default" {
  instance = google_bigtable_instance.default.name
  role     = "roles/bigtable.admin"
  member   = local.sa_member
}