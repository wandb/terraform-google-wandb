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

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)    | ~> 1.0  |
| <a name="requirement_google"></a> [google](#requirement_google)             | ~> 4.82 |
| <a name="requirement_helm"></a> [helm](#requirement_helm)                   | ~> 2.10 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement_kubernetes) | ~> 2.23 |

## Providers

No providers.

## Modules

| Name                                                                                                                                | Source                                                                    | Version |
| ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------- |
| <a name="module_app_gke"></a> [app_gke](#module_app_gke)                                                                            | ./modules/app_gke                                                         | n/a     |
| <a name="module_app_lb"></a> [app_lb](#module_app_lb)                                                                               | ./modules/app_lb                                                          | n/a     |
| <a name="module_database"></a> [database](#module_database)                                                                         | ./modules/database                                                        | n/a     |
| <a name="module_gke_app"></a> [gke_app](#module_gke_app)                                                                            | wandb/wandb/kubernetes                                                    | 1.13.0  |
| <a name="module_kms"></a> [kms](#module_kms)                                                                                        | ./modules/kms                                                             | n/a     |
| <a name="module_networking"></a> [networking](#module_networking)                                                                   | ./modules/networking                                                      | n/a     |
| <a name="module_project_factory_project_services"></a> [project_factory_project_services](#module_project_factory_project_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 13.0 |
| <a name="module_redis"></a> [redis](#module_redis)                                                                                  | ./modules/redis                                                           | n/a     |
| <a name="module_service_accounts"></a> [service_accounts](#module_service_accounts)                                                 | ./modules/service_accounts                                                | n/a     |
| <a name="module_storage"></a> [storage](#module_storage)                                                                            | ./modules/storage                                                         | n/a     |
| <a name="module_wandb"></a> [wandb](#module_wandb)                                                                                  | wandb/wandb/helm                                                          | 1.0.0   |

## Resources

No resources.

## Inputs

| Name                                                                                                         | Description                                                                                                                       | Type           | Default                                                  | Required |
| ------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------------------------------------------------------- | :------: |
| <a name="input_allowed_inbound_cidrs"></a> [allowed_inbound_cidrs](#input_allowed_inbound_cidrs)             | Which IPv4 addresses/ranges to allow access. This must be explicitly provided, and by default is set to ["*"]                     | `list(string)` | <pre>[<br> "*"<br>]</pre>                                |    no    |
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name)                                           | Use an existing bucket.                                                                                                           | `string`       | `""`                                                     |    no    |
| <a name="input_create_redis"></a> [create_redis](#input_create_redis)                                        | Boolean indicating whether to provision an redis instance (true) or not (false).                                                  | `bool`         | `false`                                                  |    no    |
| <a name="input_database_machine_type"></a> [database_machine_type](#input_database_machine_type)             | Specifies the machine type to be allocated for the database                                                                       | `string`       | `"db-n1-standard-2"`                                     |    no    |
| <a name="input_database_sort_buffer_size"></a> [database_sort_buffer_size](#input_database_sort_buffer_size) | Specifies the sort_buffer_size value to set for the database                                                                      | `number`       | `67108864`                                               |    no    |
| <a name="input_database_version"></a> [database_version](#input_database_version)                            | Version for MySQL                                                                                                                 | `string`       | `"MYSQL_8_0_31"`                                         |    no    |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection)                   | If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`. | `bool`         | `true`                                                   |    no    |
| <a name="input_disable_code_saving"></a> [disable_code_saving](#input_disable_code_saving)                   | Boolean indicating if code saving is disabled                                                                                     | `bool`         | `false`                                                  |    no    |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name)                                           | Domain for accessing the Weights & Biases UI.                                                                                     | `string`       | `null`                                                   |    no    |
| <a name="input_force_ssl"></a> [force_ssl](#input_force_ssl)                                                 | Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string                                    | `bool`         | `false`                                                  |    no    |
| <a name="input_gke_machine_type"></a> [gke_machine_type](#input_gke_machine_type)                            | Specifies the machine type to be allocated for the database                                                                       | `string`       | `"n1-standard-4"`                                        |    no    |
| <a name="input_labels"></a> [labels](#input_labels)                                                          | Labels to apply to resources                                                                                                      | `map(string)`  | `{}`                                                     |    no    |
| <a name="input_license"></a> [license](#input_license)                                                       | Your wandb/local license                                                                                                          | `string`       | n/a                                                      |   yes    |
| <a name="input_local_restore"></a> [local_restore](#input_local_restore)                                     | Restores W&B to a stable state if needed                                                                                          | `bool`         | `false`                                                  |    no    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                                                 | String used for prefix resources.                                                                                                 | `string`       | n/a                                                      |   yes    |
| <a name="input_network"></a> [network](#input_network)                                                       | Pre-existing network self link                                                                                                    | `string`       | `null`                                                   |    no    |
| <a name="input_oidc_auth_method"></a> [oidc_auth_method](#input_oidc_auth_method)                            | OIDC auth method                                                                                                                  | `string`       | `"implicit"`                                             |    no    |
| <a name="input_oidc_client_id"></a> [oidc_client_id](#input_oidc_client_id)                                  | The Client ID of application in your identity provider                                                                            | `string`       | `""`                                                     |    no    |
| <a name="input_oidc_issuer"></a> [oidc_issuer](#input_oidc_issuer)                                           | A url to your Open ID Connect identity provider, i.e. https://cognito-idp.us-east-1.amazonaws.com/us-east-1_uiIFNdacd             | `string`       | `""`                                                     |    no    |
| <a name="input_oidc_secret"></a> [oidc_secret](#input_oidc_secret)                                           | The Client secret of application in your identity provider                                                                        | `string`       | `""`                                                     |    no    |
| <a name="input_other_wandb_env"></a> [other_wandb_env](#input_other_wandb_env)                               | Extra environment variables for W&B                                                                                               | `map(string)`  | `{}`                                                     |    no    |
| <a name="input_redis_reserved_ip_range"></a> [redis_reserved_ip_range](#input_redis_reserved_ip_range)       | Reserved IP range for REDIS peering connection                                                                                    | `string`       | `"10.30.0.0/16"`                                         |    no    |
| <a name="input_resource_limits"></a> [resource_limits](#input_resource_limits)                               | Specifies the resource limits for the wandb deployment                                                                            | `map(string)`  | <pre>{<br> "cpu": null,<br> "memory": null<br>}</pre>    |    no    |
| <a name="input_resource_requests"></a> [resource_requests](#input_resource_requests)                         | Specifies the resource requests for the wandb deployment                                                                          | `map(string)`  | <pre>{<br> "cpu": "2000m",<br> "memory": "2G"<br>}</pre> |    no    |
| <a name="input_ssl"></a> [ssl](#input_ssl)                                                                   | Enable SSL certificate                                                                                                            | `bool`         | `true`                                                   |    no    |
| <a name="input_subdomain"></a> [subdomain](#input_subdomain)                                                 | Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route.                                         | `string`       | `null`                                                   |    no    |
| <a name="input_subnetwork"></a> [subnetwork](#input_subnetwork)                                              | Pre-existing subnetwork self link                                                                                                 | `string`       | `null`                                                   |    no    |
| <a name="input_use_internal_queue"></a> [use_internal_queue](#input_use_internal_queue)                      | Uses an internal redis queue instead of using google pubsub.                                                                      | `bool`         | `false`                                                  |    no    |
| <a name="input_wandb_image"></a> [wandb_image](#input_wandb_image)                                           | Docker repository of to pull the wandb image from.                                                                                | `string`       | `"wandb/local"`                                          |    no    |
| <a name="input_wandb_version"></a> [wandb_version](#input_wandb_version)                                     | The version of Weights & Biases local to deploy.                                                                                  | `string`       | `"latest"`                                               |    no    |

## Outputs

| Name                                                                                                              | Description                                                                     |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| <a name="output_address"></a> [address](#output_address)                                                          | n/a                                                                             |
| <a name="output_bucket_name"></a> [bucket_name](#output_bucket_name)                                              | Name of google bucket.                                                          |
| <a name="output_bucket_queue_name"></a> [bucket_queue_name](#output_bucket_queue_name)                            | Pubsub queue created for google bucket file upload events.                      |
| <a name="output_cluster_ca_certificate"></a> [cluster_ca_certificate](#output_cluster_ca_certificate)             | Certificate of the kubernetes (GKE) cluster.                                    |
| <a name="output_cluster_client_certificate"></a> [cluster_client_certificate](#output_cluster_client_certificate) | n/a                                                                             |
| <a name="output_cluster_client_key"></a> [cluster_client_key](#output_cluster_client_key)                         | n/a                                                                             |
| <a name="output_cluster_endpoint"></a> [cluster_endpoint](#output_cluster_endpoint)                               | Endpoint of the kubernetes (GKE) cluster.                                       |
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id)                                                 | ID of the kubernetes (GKE) cluster.                                             |
| <a name="output_cluster_name"></a> [cluster_name](#output_cluster_name)                                           | n/a                                                                             |
| <a name="output_cluster_node_pool"></a> [cluster_node_pool](#output_cluster_node_pool)                            | Default node pool where Weights & Biases should be deployed into.               |
| <a name="output_cluster_self_link"></a> [cluster_self_link](#output_cluster_self_link)                            | Self link of the kubernetes (GKE) cluster.                                      |
| <a name="output_database_connection_string"></a> [database_connection_string](#output_database_connection_string) | Full database connection string. You must be in the VPC to access the database. |
| <a name="output_fqdn"></a> [fqdn](#output_fqdn)                                                                   | The FQDN to the W&B application                                                 |
| <a name="output_service_account"></a> [service_account](#output_service_account)                                  | Weights & Biases service account used to manage resources.                      |
| <a name="output_url"></a> [url](#output_url)                                                                      | The URL to the W&B application                                                  |

<!-- END_TF_DOCS -->
