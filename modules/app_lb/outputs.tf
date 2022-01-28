output "certificate_name" {
  value = google_compute_managed_ssl_certificate.default.name
}

output "ip_address" {
  value = google_compute_global_address.default.address
}

output "ip_name" {
  value = google_compute_global_address.default.name
}