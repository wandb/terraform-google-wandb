resource "google_compute_global_address" "operator" {
  name = "${var.namespace}-operator-address"
}

module "https" {
  count = var.ssl ? 1 : 0

  source    = "./https"
  fqdn      = var.fqdn
  namespace = var.namespace

  labels = var.labels
}

##########################################
# Default Load Balancer Security Policy  #
##########################################
resource "google_compute_security_policy" "default" {
  name        = "${var.namespace}-default-security-policy"
  description = "security policy"
  type        = "CLOUD_ARMOR"
}

resource "google_compute_security_policy_rule" "allow_internal" {
  security_policy = google_compute_security_policy.default.name
  description     = "Allowed internal CIDRs"
  priority        = 1000
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["10.0.0.0/8"]
    }
  }
  action = "allow"
}

locals {
  cidrs_chunked = [
    for i in range(0, ceil(length(var.allowed_inbound_cidrs) / 10)) :
    slice(var.allowed_inbound_cidrs, i * 10, min((i + 1) * 10, length(var.allowed_inbound_cidrs)))
  ]
}

resource "google_compute_security_policy_rule" "allow_cidrs" {
  for_each        = { for idx, cidrs in local.cidrs_chunked : idx => cidrs }
  security_policy = google_compute_security_policy.default.name
  description     = "Allowed CIDRs chunk ${each.key + 1}"
  priority        = 1001 + each.key
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = each.value
    }
  }
  action = "allow"
}

resource "google_compute_security_policy_rule" "default_rule" {
  security_policy = google_compute_security_policy.default.name
  description     = "default deny"
  action          = "deny(403)"
  priority        = 2147483646
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["*"]
    }
  }
}
