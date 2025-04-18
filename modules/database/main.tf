# Random string to use as master password
resource "random_string" "master_password" {
  length  = 32
  special = false
}

locals {
  version_list   = split("_", var.database_version)
  version_kepper = "${local.version_list[0]}_${local.version_list[1]}_${local.version_list[2]}"
}

resource "random_pet" "mysql" {
  length = 2
  keepers = {
    version = local.version_kepper
  }
}

locals {
  database_name = "wandb_local"

  master_username = "wandb"
  master_password = random_string.master_password.result

  master_instance_name = "${var.namespace}-${random_pet.mysql.id}"
}

data "google_project" "default" {
}

locals {
  default_flags = {
    "binlog_row_image"           = "minimal"
    "binlog_row_value_options"   = "PARTIAL_JSON"
    "innodb_autoinc_lock_mode"   = "2"
    "innodb_lru_scan_depth"      = "100"
    "innodb_print_all_deadlocks" = "off"
    "local_infile"               = "on"
    "long_query_time"            = "1"
    "max_prepared_stmt_count"    = "1048576"
    "max_execution_time"         = "60000"
    "slow_query_log"             = "on"
    "sort_buffer_size"           = var.sort_buffer_size
    "skip_show_database"         = "on"
  }
  database_flags = merge(local.default_flags, var.database_flags)
}

resource "google_sql_database_instance" "default" {
  name                = local.master_instance_name
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  encryption_key_name = var.crypto_key

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    edition           = var.edition
    data_cache_config {
      data_cache_enabled = var.data_cache_enabled
    }
    user_labels                 = var.labels
    deletion_protection_enabled = var.deletion_protection

    backup_configuration {
      binary_log_enabled             = true
      enabled                        = true
      transaction_log_retention_days = var.edition == "ENTERPRISE_PLUS" ? 14 : 7
      backup_retention_settings {
        retained_backups = var.edition == "ENTERPRISE_PLUS" ? 15 : 7
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_connection.network
      require_ssl     = var.force_ssl
    }

    dynamic "database_flags" {
      for_each = local.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
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
