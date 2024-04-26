output "address" {
  value = module.app_lb.address_operator
}
output "bucket_name" {
  value       = local.bucket
  description = "Name of google bucket."
}

output "bucket_queue_name" {
  value       = local.bucket_queue
  description = "Pubsub queue created for google bucket file upload events."
}
output "cluster_ca_certificate" {
  value       = var.create_gke ? module.app_gke.0.cluster_ca_certificate : null
  sensitive   = true
  description = "Certificate of the kubernetes (GKE) cluster."
}

output "cluster_client_certificate" {
  sensitive = true
  value     = var.create_gke ? module.app_gke.0.cluster_client_certificate : null
}

output "cluster_client_key" {
  sensitive = true
  value     = var.create_gke ? module.app_gke.0.cluster_client_key : null
}
output "cluster_endpoint" {
  value       = var.create_gke ? module.app_gke.0.cluster_endpoint : null
  description = "Endpoint of the kubernetes (GKE) cluster."
}

output "cluster_id" {
  value       = var.create_gke ? module.app_gke.0.cluster_id : null
  description = "ID of the kubernetes (GKE) cluster."
}

output "cluster_name" {
  value = var.create_gke ? module.app_gke.0.cluster_name : null
}

output "cluster_node_pool" {
  value       = var.create_gke ? module.app_gke.0.node_pool : null
  description = "Default node pool where Weights & Biases should be deployed into."
}

output "cluster_self_link" {
  value       = var.create_gke ? module.app_gke.0.cluster_self_link : null
  description = "Self link of the kubernetes (GKE) cluster."
}

output "database_connection_string" {
  value       = var.create_database ? module.database.0.connection_string : null
  sensitive   = true
  description = "Full database connection string. You must be in the VPC to access the database."
}

output "fqdn" {
  value       = local.fqdn
  description = "The FQDN to the W&B application"
}

output "service_account" {
  value       = module.service_accounts.service_account
  description = "Weights & Biases service account used to manage resources."
}
output "url" {
  value       = local.url
  description = "The URL to the W&B application"
}

output "standardized_size" {
  value = var.size
}

output "gke_node_count" {
  value = coalesce(try(local.deployment_size[var.size].node_count, null), var.gke_node_count)
}

output "gke_node_instance_type" {
  value = coalesce(try(local.deployment_size[var.size].node_instance, null), var.gke_machine_type)
}

output "database_instance_type" {
  value = coalesce(try(local.deployment_size[var.size].db, null), var.database_machine_type)
}



