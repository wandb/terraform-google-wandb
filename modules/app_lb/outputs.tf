output "address" {
  value = google_compute_global_address.default.address
}

output "address_operator_name" {
  value = google_compute_global_address.operator.name
}
