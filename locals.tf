locals {
  bucket                  = local.create_bucket ? module.storage.0.bucket_name : var.bucket_name
  bucket_queue            = var.use_internal_queue ? "internal://" : "pubsub:/${module.storage.0.bucket_queue_name}"
  create_bucket           = var.bucket_name == ""
  create_network          = var.network == null
  crypto_key              = var.use_internal_queue ? null : module.kms.0.crypto_key
  fqdn                    = var.subdomain == null ? var.domain_name : "${var.subdomain}.${var.domain_name}"
  internal_app_port       = 32543
  network                 = try(module.networking.0.network, { self_link = var.network })
  network_connection      = try(module.networking.0.connection, { network = var.network })
  redis_certificate       = var.create_redis ? module.redis.0.ca_cert : null
  redis_connection_string = var.create_redis ? "redis://:${module.redis.0.auth_string}@${module.redis.0.connection_string}?tls=true&ttlInSeconds=604800&caCertPath=/etc/ssl/certs/server_ca.pem" : null
  subnetwork              = try(module.networking.0.subnetwork, { self_link = var.subnetwork })
  url                     = "${local.url_prefix}://${local.fqdn}"
  url_prefix              = var.ssl ? "https" : "http"
}
