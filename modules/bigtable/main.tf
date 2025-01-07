locals {
  sa_member = "serviceAccount:${var.service_account_email}"
}

locals {
  # google_bigtable_instance.cluster.cluster_id has a min length of 6 and a max length of 30
  instance_name = (length(var.namespace)) < 6 ? "${var.namespace}-bt" : var.namespace
  trimmed_instance_name = length(local.instance_name) > 27 ? substr(local.instance_name, 0, 27) : local.instance_name
}

resource "google_bigtable_instance" "default" {
  name                = local.trimmed_instance_name
  deletion_protection = var.deletion_protection
  force_destroy       = !var.deletion_protection

  cluster {
    cluster_id   = "${local.trimmed_instance_name}-c1"
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

resource "google_bigtable_gc_policy" "omni_history" {
  instance_name = google_bigtable_instance.default.name
  table         = google_bigtable_table.omni_history.name
  column_family = "x"
  max_version {
    number = 1
  }
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

resource "google_bigtable_gc_policy" "omni_history_lookup" {
  instance_name = google_bigtable_instance.default.name
  table         = google_bigtable_table.omni_history_lookup.name
  column_family = "x"
  max_version {
    number = 1
  }
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

resource "google_bigtable_gc_policy" "runs_data" {
  instance_name = google_bigtable_instance.default.name
  table         = google_bigtable_table.runs.name
  column_family = "data"
  max_version {
    number = 1
  }
}

resource "google_bigtable_gc_policy" "runs_metadata" {
  instance_name = google_bigtable_instance.default.name
  table         = google_bigtable_table.runs.name
  column_family = "metadata"
  max_version {
    number = 1
  }
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

resource "google_bigtable_gc_policy" "logs" {
  instance_name = google_bigtable_instance.default.name
  table         = google_bigtable_table.logs.name
  column_family = "line"
  max_version {
    number = 1
  }
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

resource "google_bigtable_gc_policy" "history" {
  instance_name = google_bigtable_instance.default.name
  table         = google_bigtable_table.history.name
  column_family = "event"
  max_version {
    number = 1
  }
}