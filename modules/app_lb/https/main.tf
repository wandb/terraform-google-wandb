resource "random_pet" "cert" {
  length = 2
  keepers = {
    fqdn = var.fqdn
  }
}


# Create a managed SSL certificate that's issued and renewed by Google
resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.namespace}-cert-${random_pet.cert.id}"

  managed {
    domains = [var.fqdn]
  }

  lifecycle {
    create_before_destroy = true
  }
}
