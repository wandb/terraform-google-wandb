# Weights & Biases Google Module

This is a Terraform module for provisioning a Weights & Biases Cluster on Google
Cloud. Weights & Biases Local is our self-hosted distribution of wandb.ai. It
offers enterprises a private instance of the Weights & Biases application, with
no resource limits and with additional enterprise-grade architectural features
like audit logging and single sign-on.

## About This Module

## Pre-requisites

This module is intended to run in an Google Cloud account with minimal
preparation, however it does have the following pre-requisites:

### Terrafom version >= 1

### Credentials / Permissions

**Google Services Used**

- Google SQL Cloud (MySQL)
- Google Kubernetes Engine
- Google Storage Bucket
- Google PubSub
- Google Managed Certificates
- Google Cloud DNS

## How to Use This Module

- Ensure account meets module pre-requisites from above.
- Create a Terraform configuration that pulls in this module and specifies
  values of the required variables:

```hcl
provider "google" {
  project = "<desired google project>"
  region = "<desired google region>"
  zone = "<desired google zone>"
}

module "wandb" {
  source    = "<filepath to cloned module directory>"
  namespace = "<prefix for naming google resources>"
}
```

- Run `terraform init` and `terraform apply`

## Examples

We have included documentation and reference examples for additional common
installation scenarios for Weights & Biases, as well as examples for supporting
resources that lack official modules.

- [Public Instance with HTTPS using Cloud DNS](examples/public-dns-with-cloud-dns)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.31 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.9 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_gke"></a> [app\_gke](#module\_app\_gke) | ./modules/app_gke | n/a |
| <a name="module_app_lb"></a> [app\_lb](#module\_app\_lb) | ./modules/app_lb | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_gke_app"></a> [gke\_app](#module\_gke\_app) | wandb/wandb/kubernetes | 1.6.0 |
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/kms | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_project_factory_project_services"></a> [project\_factory\_project\_services](#module\_project\_factory\_project\_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 13.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | ./modules/redis | n/a |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | ./modules/service_accounts | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_inbound_cidr"></a> [allowed\_inbound\_cidr](#input\_allowed\_inbound\_cidr) | (Optional) Allow HTTP(S) traffic to W&B. Defaults to all connections. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Use an existing bucket. | `string` | `""` | no |
| <a name="input_create_redis"></a> [create\_redis](#input\_create\_redis) | Boolean indicating whether to provision an redis instance (true) or not (false). | `bool` | `false` | no |
| <a name="input_database_machine_type"></a> [database\_machine\_type](#input\_database\_machine\_type) | Specifies the machine type to be allocated for the database | `string` | `"db-n1-standard-2"` | no |
| <a name="input_database_sort_buffer_size"></a> [database\_sort\_buffer\_size](#input\_database\_sort\_buffer\_size) | Specifies the sort\_buffer\_size value to set for the database | `number` | `67108864` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Version for MySQL | `string` | `"MYSQL_8_0_31"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`. | `bool` | `true` | no |
| <a name="input_disable_code_saving"></a> [disable\_code\_saving](#input\_disable\_code\_saving) | Boolean indicating if code saving is disabled | `bool` | `false` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain for accessing the Weights & Biases UI. | `string` | `null` | no |
| <a name="input_force_ssl"></a> [force\_ssl](#input\_force\_ssl) | Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string | `bool` | `false` | no |
| <a name="input_gke_machine_type"></a> [gke\_machine\_type](#input\_gke\_machine\_type) | Specifies the machine type to be allocated for the database | `string` | `"n1-standard-4"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to resources | `map(string)` | `{}` | no |
| <a name="input_license"></a> [license](#input\_license) | Your wandb/local license | `string` | n/a | yes |
| <a name="input_local_restore"></a> [local\_restore](#input\_local\_restore) | Restores W&B to a stable state if needed | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | String used for prefix resources. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Pre-existing network self link | `string` | `null` | no |
| <a name="input_oidc_auth_method"></a> [oidc\_auth\_method](#input\_oidc\_auth\_method) | OIDC auth method | `string` | `"implicit"` | no |
| <a name="input_oidc_client_id"></a> [oidc\_client\_id](#input\_oidc\_client\_id) | The Client ID of application in your identity provider | `string` | `""` | no |
| <a name="input_oidc_issuer"></a> [oidc\_issuer](#input\_oidc\_issuer) | A url to your Open ID Connect identity provider, i.e. https://cognito-idp.us-east-1.amazonaws.com/us-east-1_uiIFNdacd | `string` | `""` | no |
| <a name="input_oidc_secret"></a> [oidc\_secret](#input\_oidc\_secret) | The Client secret of application in your identity provider | `string` | `""` | no |
| <a name="input_other_wandb_env"></a> [other\_wandb\_env](#input\_other\_wandb\_env) | Extra environment variables for W&B | `map(string)` | `{}` | no |
| <a name="input_ssl"></a> [ssl](#input\_ssl) | Enable SSL certificate | `bool` | `true` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route. | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Pre-existing subnetwork self link | `string` | `null` | no |
| <a name="input_use_internal_queue"></a> [use\_internal\_queue](#input\_use\_internal\_queue) | Uses an internal redis queue instead of using google pubsub. | `bool` | `false` | no |
| <a name="input_wandb_image"></a> [wandb\_image](#input\_wandb\_image) | Docker repository of to pull the wandb image from. | `string` | `"wandb/local"` | no |
| <a name="input_wandb_version"></a> [wandb\_version](#input\_wandb\_version) | The version of Weights & Biases local to deploy. | `string` | `"latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | n/a |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of google bucket. |
| <a name="output_bucket_queue_name"></a> [bucket\_queue\_name](#output\_bucket\_queue\_name) | Pubsub queue created for google bucket file upload events. |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Certificate of the kubernetes (GKE) cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint of the kubernetes (GKE) cluster. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the kubernetes (GKE) cluster. |
| <a name="output_cluster_node_pool"></a> [cluster\_node\_pool](#output\_cluster\_node\_pool) | Default node pool where Weights & Biases should be deployed into. |
| <a name="output_cluster_self_link"></a> [cluster\_self\_link](#output\_cluster\_self\_link) | Self link of the kubernetes (GKE) cluster. |
| <a name="output_database_connection_string"></a> [database\_connection\_string](#output\_database\_connection\_string) | Full database connection string. You must be in the VPC to access the database. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The FQDN to the W&B application |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Weights & Biases service account used to manage resources. |
| <a name="output_url"></a> [url](#output\_url) | The URL to the W&B application |
<!-- END_TF_DOCS -->

