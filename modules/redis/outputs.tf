output "connection_string" {
  value = "${google_redis_instance.default.host}:${google_redis_instance.default.port}"
}

output "ca_cert" {
  value = "${google_redis_instance.default.server_ca_certs[0].cert}"
}

output "auth_string" {
  value = "${google_redis_instance.default.auth_string}"
}

