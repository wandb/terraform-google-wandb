# Create a URL map that points to the GKE service
module "url_map" {
  source                = "./url_map"
  namespace             = var.namespace
  group                 = var.group
  target_port           = var.target_port
  network               = var.network
  ip_address            = var.address
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
}

module "http" {
  count = var.ssl ? 0 : 1

  source     = "./http"
  namespace  = var.namespace
  url_map    = module.url_map.app
  ip_address = var.address

  labels = var.labels
}

module "https" {
  count = var.ssl ? 1 : 0

  source             = "./https"
  fqdn               = var.fqdn
  namespace          = var.namespace
  url_map            = module.url_map.app
  ip_address         = var.address
  ssl_certificate_id = var.ssl_certificate_id

  labels = var.labels
}
