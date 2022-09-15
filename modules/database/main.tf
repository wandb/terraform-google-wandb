# Random string to use as master password
resource "random_string" "master_password" {
  length  = 32
  special = false
}

locals {
  version_list   = split(var.database_version, "_")
  version_kepper = "${version_list[0]}_${version_list[1]}_${version_list[2]}"
}

resource "random_pet" "mysql" {
  length = 2
  keepers = {
    version = var.version_kepper
  }
}

locals {
  database_name = "wandb_local"

  master_username = "wandb"
  master_password = random_string.master_password.result

  master_instance_name = "${var.namespace}-${random_pet.mysql.id}"
}

resource "google_sql_database_instance" "default" {
  name                = local.master_instance_name
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    user_labels       = var.labels

    backup_configuration {
      binary_log_enabled             = true
      enabled                        = true
      transaction_log_retention_days = 7
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_connection.network
    }

    # requires minimum memory of 26624 MB
    # database_flags {
    #   name  = "performance_schema"
    #   value = 1
    # }
    database_flags {
      name  = "slow_query_log"
      value = "on"
    }
    database_flags {
      name  = "long_query_time"
      value = 1
    }
    database_flags {
      name  = "max_prepared_stmt_count"
      value = 1048576
    }
    database_flags {
      name  = "max_execution_time"
      value = 60000
    }
    database_flags {
      name  = "sort_buffer_size"
      value = var.sort_buffer_size
    }
  }
}

resource "google_sql_database" "wandb" {
  name     = local.database_name
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "wandb" {
  instance = google_sql_database_instance.default.name
  name     = local.master_username
  password = local.master_password
}
