output "cloudnat_ip" {
  value       = google_compute_address.this.address
  description = "Cloud nat static ip"
}

output "cloudnat_lb_proxy_ip" {
  value = google_compute_address.nat_lb_proxy_address.address
}
