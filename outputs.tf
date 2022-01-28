output "url" {
  value       = local.url
  description = "The URL to the W&B application"
}

output "fqdn" {
  value       = local.fqdn
  description = "The FQDN to the W&B application"
}

output "service_account" {
  value = module.service_accounts.service_account
}

output "internal_app_port" {
  value = local.internal_app_port
}

output "database_connection_string" {
  value     = module.database.connection_string
  sensitive = true
}

output "bucket_name" {
  value = module.file_storage.bucket_name
}

output "bucket_queue_name" {
  value = module.file_storage.bucket_queue_name
}

output "cluster_node_pool" {
  value = module.app_gke.node_pool
}

output "cluster_id" {
  value = module.app_gke.cluster_id
}

output "cluster_endpoint" {
  value = module.app_gke.cluster_endpoint
}

output "cluster_ca_certificate" {
  value     = module.app_gke.cluster_ca_certificate
  sensitive = true
}

output "cluster_self_link" {
  value = module.app_gke.cluster_self_link
}
