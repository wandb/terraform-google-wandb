output "address" {
  value = google_compute_global_address.default.address
}

output "address_operator" {
  value = google_compute_global_address.operator.address
}

output "address_operator_name" {
  value = google_compute_global_address.operator.name
}

output "certificate" {
  value = module.https[0].certificate
}

output "lb_security_policy_name" {
  value = google_compute_security_policy.default.name
}
