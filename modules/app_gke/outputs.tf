
output "cluster_ca_certificate" {
  value     = google_container_cluster.default.master_auth.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_client_certificate" {
  sensitive   = true
  value = google_container_cluster.default.master_auth.0.client_certificate
}

output "cluster_client_key" {
  sensitive = true
  value = google_container_cluster.default.master_auth.0.client_key
}
output "cluster_endpoint" {
  value = google_container_cluster.default.endpoint
}
output "cluster_id" {
  value = google_container_cluster.default.id
}
output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_self_link" {
  value = google_container_cluster.default.self_link
}
output "instance_group_url" {
  value = google_container_node_pool.default.instance_group_urls[0]
}
output "node_pool" {
  value = google_container_node_pool.default
}

