output "connection_string" {
  value = "${google_redis_instance.default.host}:${google_redis_instance.default.port}"
}
