output "psc_connection_id" {
  value       = google_compute_forwarding_rule.psc_forward_rule.psc_connection_id
  description = "Add GCP PSC Connection ID to ClickHouse allow list."
}
