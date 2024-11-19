locals {
  sa_member = "serviceAccount:${var.service_account.email}"
}

resource "google_bigtable_instance" "default" {
  name                = var.namespace
  deletion_protection = var.deletion_protection
  force_destroy       = !var.deletion_protection

  cluster {
    cluster_id   = "${var.namespace}-c1"
    storage_type = var.storage_type
    kms_key_name = var.crypto_key
    autoscaling_config {
      min_nodes  = var.min_nodes
      max_nodes  = var.max_nodes
      cpu_target = var.cpu_target
    }
  }

  labels = var.labels
}

resource "google_bigtable_instance_iam_member" "default" {
  instance = google_bigtable_instance.default.name
  role     = "roles/bigtable.admin"
  member   = local.sa_member
}

resource "google_bigtable_table" "omni_history" {
  name          = "omni-history"
  instance_name = google_bigtable_instance.default.name

  deletion_protection = (var.deletion_protection) ? "PROTECTED" : "UNPROTECTED"

  column_family {
    family = "x"
  }

  change_stream_retention = "0"
}

resource "google_bigtable_table" "omni_history_lookup" {
  name          = "omni-history-lookup"
  instance_name = google_bigtable_instance.default.name

  deletion_protection = (var.deletion_protection) ? "PROTECTED" : "UNPROTECTED"

  column_family {
    family = "x"
  }

  change_stream_retention = "0"
}

resource "google_bigtable_table" "runs" {
  name          = "runs"
  instance_name = google_bigtable_instance.default.name

  deletion_protection = (var.deletion_protection) ? "PROTECTED" : "UNPROTECTED"

  column_family {
    family = "data"
  }

  column_family {
    family = "metadata"
  }

  change_stream_retention = "0"
}

resource "google_bigtable_table" "logs" {
  name          = "logs"
  instance_name = google_bigtable_instance.default.name

  deletion_protection = (var.deletion_protection) ? "PROTECTED" : "UNPROTECTED"

  column_family {
    family = "line"
  }

  change_stream_retention = "0"
}

resource "google_bigtable_table" "history" {
  name          = "history"
  instance_name = google_bigtable_instance.default.name

  deletion_protection = (var.deletion_protection) ? "PROTECTED" : "UNPROTECTED"

  column_family {
    family = "event"
  }

  change_stream_retention = "0"
}