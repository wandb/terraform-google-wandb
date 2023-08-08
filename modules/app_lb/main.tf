resource "google_compute_global_address" "default" {
  name = "${var.namespace}-address"
}
