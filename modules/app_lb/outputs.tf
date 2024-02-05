output "address_name" {
  value = google_compute_global_address.default.name
}

output "address" {
  value = google_compute_global_address.default.address
}

output "address_operator_name" {
  value = google_compute_global_address.operator.name
}

output "address_operator" {
  value = google_compute_global_address.operator.address
}
