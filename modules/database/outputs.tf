locals {
  output_private_ip                 = google_sql_database_instance.default.private_ip_address
  output_database_name              = google_sql_database.wandb.name
  output_username                   = google_sql_user.wandb.name
  output_password                   = google_sql_user.wandb.password
  output_connection_name            = replace(google_sql_database_instance.default.connection_name, ":", ".")
  output_connection_string_mysql    = "mysql://${local.output_username}:${local.output_password}@${local.output_private_ip}/${local.output_database_name}"
  output_connection_string_cloudsql = "cloudsql://${local.output_username}:${local.output_password}@${local.output_connection_name}/${local.output_database_name}"
}

output "private_ip_address" {
  value       = local.output_private_ip
  description = "The private IP address of the SQL database instance."
}

output "database_name" {
  value = local.output_database_name
}

output "username" {
  value = local.output_username
}

output "password" {
  value = local.output_password
}

output "connection_string" {
  value = var.force_ssl ? local.output_connection_string_cloudsql : local.output_connection_string_mysql
}

output "database_connection_name" {
  value = google_sql_database_instance.default.connection_name
}

