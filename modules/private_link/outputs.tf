output "private_attachement_id" {
  value = try(google_compute_service_attachment.default.id,null)
}

output "kubernetes" {
  value = data.kubernetes_ingress_v1.ingress
}