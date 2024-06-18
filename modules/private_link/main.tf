data "google_client_config" "current" {}

resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = <<EOT
      # Download and install jq
      curl -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
      chmod 0755 jq
      curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-387.0.0-linux-x86_64.tar.gz
      tar -xf google-cloud-cli-387.0.0-linux-x86_64.tar.gz
      ./google-cloud-sdk/install.sh -q
      /bin/bash /home/tfc-agent/.tfc-agent/component/terraform/runs/run-KruyrUQKD98yfjEf/config/services/deployer/terraform/deploy/google/single-tenant/google-cloud-sdk/path.bash.inc
      echo $GOOGLE_CREDENTIALS
      echo $GOOGLE_CREDENTIALS > creds.json
      echo "printing creds"
      cat creds.json
      google-cloud-sdk/bin/gcloud auth activate-service-account tf-infra-wandb-qa@wandb-qa.iam.gserviceaccount.com --key-file=creds.json --project=wandb-qa
      google-cloud-sdk/bin/gcloud compute forwarding-rules list --format=json > lb_details.json
      cat lb_details.json | jq -r '.[] | select(.name | test("${var.namespace}-internal")) | .name' > filtered_lb_names.txt
    EOT
  }
}

data "external" "filtered_lb_names" {
  program    = ["sh", "-c", "cat filtered_lb_names.txt | jq -R -s '{\"load_balancer_name\": .}'"]
  depends_on = [null_resource.install_dependencies]
}

locals {
  forwardingRules = data.external.filtered_lb_names.result["load_balancer_name"]
}


resource "google_compute_service_attachment" "default" {
  name                  = "${var.namespace}-private-link"
  enable_proxy_protocol = false
  connection_preference = "ACCEPT_MANUAL"
  nat_subnets           = [google_compute_subnetwork.default.id]
  target_service        = "https://www.googleapis.com/compute/v1/projects/${data.google_client_config.current.project}/regions/${data.google_client_config.current.region}/forwardingRules/${local.forwardingRules}"

  dynamic "consumer_accept_lists" {
    for_each = var.allowed_projects != {} ? var.allowed_projects : {}
    content {
      project_id_or_num = consumer_accept_lists.key
      connection_limit  = consumer_accept_lists.value
    }
  }
  depends_on = [data.external.filtered_lb_names]
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.namespace}-psc-ilb-subnet"
  network       = var.network.id
  purpose       = "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range = var.psc_subnetwork
}


# allow all access from IAP and health check ranges
resource "google_compute_firewall" "default" {
  name          = "${var.namespace}-internal-fw"
  provider      = google-beta
  direction     = "INGRESS"
  network       = var.network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20", var.proxynetwork_cidr]
  allow {
    protocol = "tcp"
  }
}
