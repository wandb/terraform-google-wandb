output "private_attachment_id" {
  value = try(google_compute_service_attachment.default.id, null)
}