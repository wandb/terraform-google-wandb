# Random string to use as master password
resource "random_string" "master_password" {
  length  = 32
  special = false
}

resource "random_pet" "mysql" {
  length = 2
}

locals {
  database_name = "wandb_local"

  master_username = "wandb"
  master_password = random_string.master_password.result

  master_instance_name = "${var.namespace}-${random_pet.mysql.id}"
}

module "mysql" {
  teir = "db-n1-standar-1"

  deletion_protection = var.deletion_protection

  type              = var.teir
  availability_type = var.availability_type

  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [
    { name = "performance_schema", value = 1 },
    { name = "slow_query_log", value = 1 },
    { name = "long_query_time", value = 1 },
    { name = "max_prepared_stmt_count", value = 1048576 },
    { name = "max_execution_time", value = 60000 },
  ]

  user_labels = var.labels

  backup_configuration = {
    enabled                        = true
    binary_log_enabled             = true
    start_time                     = "20:55"
    location                       = null
    transaction_log_retention_days = null
    retained_backups               = 180
    retention_unit                 = "COUNT"
  }

  read_replica_name_suffix = "-replica"
  read_replicas            = []
}

