# Random string to use as master password
resource "random_string" "master_password" {
  length  = 32
  special = false
}

resource "random_pet" "mysql" {
  length = 2
}

locals {
  database_version = 5.7
  database_name    = "wandb_local"

  master_username = "wandb"
  master_password = random_string.master_password.result

  master_instance_name = "${var.namespace}-${random_pet.mysql.id}"
}

# module "mysql" {
#   source  = "GoogleCloudPlatform/sql-db/google//modules/safer_mysql"
#   version = "8.0.0"

#   teir = "db-n1-standar-1"

#   deletion_protection = var.deletion_protection

#   type              = var.teir
#   availability_type = var.availability_type

#   maintenance_window_day          = 7
#   maintenance_window_hour         = 12
#   maintenance_window_update_track = "stable"

#   user_labels = var.labels

#   backup_configuration = {
#     enabled                        = true
#     binary_log_enabled             = true
#     start_time                     = "20:55"
#     location                       = null
#     transaction_log_retention_days = null
#     retained_backups               = 180
#     retention_unit                 = "COUNT"
#   }

#   read_replica_name_suffix = "-replica"
#   read_replicas            = []
# }

resource "google_sql_database_instance" "default" {
  # project = var.project_id
  name                = local.master_instance_name
  database_version    = local.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    availability_type = var.availability_type

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
      private_network = var.vpc_network_id
    }

    database_flags {
      name  = "performance_schema"
      value = 1
    }
    database_flags {
      name  = "slow_query_log"
      value = 1
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
  }
}
