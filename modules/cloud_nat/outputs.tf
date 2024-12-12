output "cloudnat_ip" {
  value       = google_compute_address.this.address
  description = "Cloud nat static ip"
}
