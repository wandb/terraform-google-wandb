output "private_ip_address" {
  value       = google_sql_database_instance.default.private_ip_address
  description = "The private IP address of the SQL database instance."
}

output "database_name" {
  value = google_sql_database.wandb.name
}

output "username" {
  value = google_sql_user.wandb.name
}

output "password" {
  value = google_sql_user.wandb.password
}