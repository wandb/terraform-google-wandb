resource "google_compute_global_address" "default" {
  name = "${var.namespace}-address"
}

resource "google_compute_global_address" "operator" {
  name = "${var.namespace}-operator-address"
}

module "https" {
  count = var.ssl ? 1 : 0

  source     = "./https"
  fqdn       = var.fqdn
  namespace  = var.namespace
  ip_address = google_compute_global_address.default.address

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
/*
resource "google_compute_security_policy_rule" "block_country" {
  security_policy = google_compute_security_policy.default.name
  priority        = 1000
  action          = "deny(403)"

  match {
    expr {
      expression = "origin.region_code == \"IR\" || origin.region_code == \"KP\""
    }
  }
}
*/
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

resource "google_compute_security_policy_rule" "allow_cidrs" {
  security_policy = google_compute_security_policy.default.name
  description     = "Allowed CIDRs"
  priority        = 1001
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = var.allowed_inbound_cidrs
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
