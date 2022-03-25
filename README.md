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

module "wandb_infra" {
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
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.15 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.9 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_gke"></a> [app\_gke](#module\_app\_gke) | ./modules/app_gke | n/a |
| <a name="module_app_lb"></a> [app\_lb](#module\_app\_lb) | ./modules/app_lb | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_file_storage"></a> [file\_storage](#module\_file\_storage) | ./modules/file_storage | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_project_factory_project_services"></a> [project\_factory\_project\_services](#module\_project\_factory\_project\_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 11.3 |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | ./modules/service_accounts | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Version for MySQL | `string` | `"MYSQL_5_7"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`. | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain for accessing the Weights & Biases UI. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to resources | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | String used for prefix resources. | `string` | n/a | yes |
| <a name="input_ssl"></a> [ssl](#input\_ssl) | Enable SSL certificate | `bool` | `true` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route. | `string` | `null` | no |
| <a name="input_use_internal_queue"></a> [use\_internal\_queue](#input\_use\_internal\_queue) | Uses an internal redis queue instead of using google pubsub. | `bool` | `false` | no |

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

## FQA

**Why do I need two different modules?**

Weights & Biases uses 2 providers, one for the cloud platform and one for kubernetes.

> A module intended to be called by one or more other modules must not contain
> any provider blocks. A module containing its own provider configurations is
> not compatible with the for_each, count, and depends_on arguments that were
> introduced in Terraform v0.13. For more information, see Legacy Shared Modules
> with Provider Configurations.
>
> Provider configurations are used for all operations on associated resources,
> including destroying remote objects and refreshing state. Terraform retains, as
> part of its state, a reference to the provider configuration that was most
> recently used to apply changes to each resource. When a resource block is
> removed from the configuration, this record in the state will be used to locate
> the appropriate configuration because the resource's provider argument (if any)
> will no longer be present in the configuration.
>
> As a consequence, you must ensure that all resources that belong to a
> particular provider configuration are destroyed before you can remove that
> provider configuration's block from your configuration. If Terraform finds a
> resource instance tracked in the state whose provider configuration block is
> no longer available then it will return an error during planning, prompting
> you to reintroduce the provider configuration.

https://www.terraform.io/language/modules/develop/providers
