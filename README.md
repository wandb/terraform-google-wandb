# Weights & Biases Google Module

**IMPORTANT:** You are viewing a beta version of the official module to install
Weights & Biases. This new version is incompatible with earlier versions, and it
is not currently meant for production use. Please contact your Customer Success
Manager for details before using.

This is a Terraform module for provisioning a Weights & Biases Cluster on Google
Cloud. Weights & Biases Local is our self-hosted distribution of wandb.ai. It
offers enterprises a private instance of the Weights & Biases application, with
no resource limits and with additional enterprise-grade architectural features
like audit logging and SAML single sign-on.

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
| <a name="requirement_google"></a> [google](#requirement_google)             | ~> 4.15 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement_kubernetes) | ~> 2.9  |

## Providers

No providers.

## Modules

| Name                                                                                                                                | Source                                                                    | Version |
| ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------- |
| <a name="module_app_gke"></a> [app_gke](#module_app_gke)                                                                            | ./modules/app_gke                                                         | n/a     |
| <a name="module_app_lb"></a> [app_lb](#module_app_lb)                                                                               | ./modules/app_lb                                                          | n/a     |
| <a name="module_database"></a> [database](#module_database)                                                                         | ./modules/database                                                        | n/a     |
| <a name="module_file_storage"></a> [file_storage](#module_file_storage)                                                             | ./modules/file_storage                                                    | n/a     |
| <a name="module_gke_app"></a> [gke_app](#module_gke_app)                                                                            | wandb/wandb/kubernetes                                                    | 1.0.2   |
| <a name="module_kms"></a> [kms](#module_kms)                                                                                        | ./modules/kms                                                             | n/a     |
| <a name="module_networking"></a> [networking](#module_networking)                                                                   | ./modules/networking                                                      | n/a     |
| <a name="module_project_factory_project_services"></a> [project_factory_project_services](#module_project_factory_project_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 11.3 |
| <a name="module_service_accounts"></a> [service_accounts](#module_service_accounts)                                                 | ./modules/service_accounts                                                | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                                       | Description                                                                                                                       | Type          | Default         | Required |
| ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- | ------------- | --------------- | :------: |
| <a name="input_database_version"></a> [database_version](#input_database_version)          | Version for MySQL                                                                                                                 | `string`      | `"MYSQL_5_7"`   |    no    |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection) | If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`. | `bool`        | `true`          |    no    |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name)                         | Domain for accessing the Weights & Biases UI.                                                                                     | `string`      | `null`          |    no    |
| <a name="input_labels"></a> [labels](#input_labels)                                        | Labels to apply to resources                                                                                                      | `map(string)` | `{}`            |    no    |
| <a name="input_license"></a> [license](#input_license)                                     | Your wandb/local license                                                                                                          | `string`      | n/a             |   yes    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                               | String used for prefix resources.                                                                                                 | `string`      | n/a             |   yes    |
| <a name="input_oidc_auth_method"></a> [oidc_auth_method](#input_oidc_auth_method)          | OIDC auth method                                                                                                                  | `string`      | `"implicit"`    |    no    |
| <a name="input_oidc_client_id"></a> [oidc_client_id](#input_oidc_client_id)                | The Client ID of application in your identity provider                                                                            | `string`      | `""`            |    no    |
| <a name="input_oidc_issuer"></a> [oidc_issuer](#input_oidc_issuer)                         | A url to your Open ID Connect identity provider, i.e. https://cognito-idp.us-east-1.amazonaws.com/us-east-1_uiIFNdacd             | `string`      | `""`            |    no    |
| <a name="input_ssl"></a> [ssl](#input_ssl)                                                 | Enable SSL certificate                                                                                                            | `bool`        | `true`          |    no    |
| <a name="input_subdomain"></a> [subdomain](#input_subdomain)                               | Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route.                                         | `string`      | `null`          |    no    |
| <a name="input_use_internal_queue"></a> [use_internal_queue](#input_use_internal_queue)    | Uses an internal redis queue instead of using google pubsub.                                                                      | `bool`        | `false`         |    no    |
| <a name="input_wandb_image"></a> [wandb_image](#input_wandb_image)                         | Docker repository of to pull the wandb image from.                                                                                | `string`      | `"wandb/local"` |    no    |
| <a name="input_wandb_version"></a> [wandb_version](#input_wandb_version)                   | The version of Weights & Biases local to deploy.                                                                                  | `string`      | `"latest"`      |    no    |

## Outputs

| Name                                                                                                              | Description                                                                     |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| <a name="output_address"></a> [address](#output_address)                                                          | n/a                                                                             |
| <a name="output_bucket_name"></a> [bucket_name](#output_bucket_name)                                              | Name of google bucket.                                                          |
| <a name="output_bucket_queue_name"></a> [bucket_queue_name](#output_bucket_queue_name)                            | Pubsub queue created for google bucket file upload events.                      |
| <a name="output_cluster_ca_certificate"></a> [cluster_ca_certificate](#output_cluster_ca_certificate)             | Certificate of the kubernetes (GKE) cluster.                                    |
| <a name="output_cluster_endpoint"></a> [cluster_endpoint](#output_cluster_endpoint)                               | Endpoint of the kubernetes (GKE) cluster.                                       |
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id)                                                 | ID of the kubernetes (GKE) cluster.                                             |
| <a name="output_cluster_node_pool"></a> [cluster_node_pool](#output_cluster_node_pool)                            | Default node pool where Weights & Biases should be deployed into.               |
| <a name="output_cluster_self_link"></a> [cluster_self_link](#output_cluster_self_link)                            | Self link of the kubernetes (GKE) cluster.                                      |
| <a name="output_database_connection_string"></a> [database_connection_string](#output_database_connection_string) | Full database connection string. You must be in the VPC to access the database. |
| <a name="output_fqdn"></a> [fqdn](#output_fqdn)                                                                   | The FQDN to the W&B application                                                 |
| <a name="output_service_account"></a> [service_account](#output_service_account)                                  | Weights & Biases service account used to manage resources.                      |
| <a name="output_url"></a> [url](#output_url)                                                                      | The URL to the W&B application                                                  |

<!-- END_TF_DOCS -->
