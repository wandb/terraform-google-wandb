output "app" {
  value = google_compute_url_map.default
}

output "internal" {
  value = google_compute_region_url_map.internal
}
