output "bigtable_instance_id" {
  value = google_bigtable_instance.default.name
}

output "bigtable_project_id" {
  value = google_bigtable_instance.default.project
}