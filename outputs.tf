output "address" {
  value = module.app_lb.address_operator
}
output "bucket_name" {
  value       = local.bucket
  description = "Name of google bucket."
}
output "bucket_path" {
  value       = local.bucket_path
  description = "path of where to store data for the instance-level bucket"
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

output "standardized_size" {
  value = var.size
}

output "gke_node_count" {
  value = local.min_node_count
}

output "gke_max_node_count" {
  value = local.max_node_count
}

output "gke_node_instance_type" {
  value = local.gke_machine_type
}

output "database_instance_type" {
  value = local.database_machine_type
}

output "private_attachment_id" {
  value = var.create_private_link ? module.private_link[0].private_attachment_id : null
}

output "sa_account_email" {
  description = "This output provides the email address of the service account created for workload identity, if workload identity is enabled. Otherwise, it returns null"
  value       = var.create_workload_identity == true ? module.service_accounts.sa_account_role : null
}

output "clickhouse_private_endpoint_id" {
  description = "ClickHouse Private endpoint Endpoint ID to secure access inside VPC"
  value       = var.clickhouse_private_endpoint_service_name != "" ? module.clickhouse[0].psc_connection_id : null
}

output "oidc_issuer" {
  value = local.issuer_url
}

output "cluster_location" {
  value = module.app_gke.location
}

output "wandb_spec" {
  value     = local.spec
  sensitive = true
}
