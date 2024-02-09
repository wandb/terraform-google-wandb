output "address" {
  value = var.enable_operator ? module.app_lb.address_operator : module.app_lb.address
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
  value       = module.app_gke.cluster_ca_certificate
  sensitive   = true
  description = "Certificate of the kubernetes (GKE) cluster."
}

output "cluster_client_certificate" {
  sensitive = true
  value     = module.app_gke.cluster_client_certificate
}

output "cluster_client_key" {
  sensitive = true
  value     = module.app_gke.cluster_client_key
}
output "cluster_endpoint" {
  value       = module.app_gke.cluster_endpoint
  description = "Endpoint of the kubernetes (GKE) cluster."
}

output "cluster_id" {
  value       = module.app_gke.cluster_id
  description = "ID of the kubernetes (GKE) cluster."
}

output "cluster_name" {
  value = module.app_gke.cluster_name
}

output "cluster_node_pool" {
  value       = module.app_gke.node_pool
  description = "Default node pool where Weights & Biases should be deployed into."
}

output "cluster_self_link" {
  value       = module.app_gke.cluster_self_link
  description = "Self link of the kubernetes (GKE) cluster."
}

output "database_connection_string" {
  value       = module.database.connection_string
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









