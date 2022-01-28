# GCP allows use to create the load balance in the kubernetes cluster, all we
# need to do is create an ip address for it to use and a managed certificate. 
#
# In other providers like AWS, we need to do this all outside of this work
# outside of the cluster.
#
# Checkout the terraform-kubernetes-wandb/modules/gcp to see how this is done.

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.namespace}-cert"

  managed {
    domains = [var.fqdn]
  }
}

resource "google_compute_global_address" "default" {
  name = "${var.namespace}-address"
}
