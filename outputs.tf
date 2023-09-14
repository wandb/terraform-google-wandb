output "url" {
  value       = local.url
  description = "The URL to the W&B application"
}

output "fqdn" {
  value       = local.fqdn
  description = "The FQDN to the W&B application"
}

output "service_account" {
  value       = module.service_accounts.service_account
  description = "Weights & Biases service account used to manage resources."
}

output "database_connection_string" {
  value       = module.database.connection_string
  sensitive   = true
  description = "Full database connection string. You must be in the VPC to access the database."
}

output "bucket_name" {
  value       = local.bucket
  description = "Name of google bucket."
}

output "bucket_queue_name" {
  value       = local.bucket_queue
  description = "Pubsub queue created for google bucket file upload events."
}

output "cluster_node_pool" {
  value       = module.app_gke.node_pool
  description = "Default node pool where Weights & Biases should be deployed into."
}

output "cluster_id" {
  value       = module.app_gke.cluster_id
  description = "ID of the kubernetes (GKE) cluster."
}

output "cluster_endpoint" {
  value       = module.app_gke.cluster_endpoint
  description = "Endpoint of the kubernetes (GKE) cluster."
}

output "cluster_ca_certificate" {
  value       = module.app_gke.cluster_ca_certificate
  sensitive   = true
  description = "Certificate of the kubernetes (GKE) cluster."
}

output "cluster_self_link" {
  value       = module.app_gke.cluster_self_link
  description = "Self link of the kubernetes (GKE) cluster."
}

output "address" {
  value = module.app_lb.address
}

output "network" {
  value       = module.networking.network
  description = "The network."
}

output "subnetwork" {
  value = module.networking.subnetwork

  description = "The subnetwork."
}

output "connection" {
  description = "The private connection between the network and GCP services."
  value       = module.networking.connection
}
