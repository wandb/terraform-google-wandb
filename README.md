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

## Cluster Sizing

By default, the type of kubernetes instances, number of instances, redis cluster size, and database instance sizes are
standardized via configurations in [./deployment-size.tf](deployment-size.tf), and is configured via the `size` input 
variable.

Available sizes are, `small`, `medium`, `large`, `xlarge`, and `xxlarge`.  Default is `small`.

All the values set via `deployment-size.tf` can be overridden by setting the appropriate input variables.

- `gke_machine_type` - The instance type for the GKE nodes
- `gke_min_node_count` - The minimum number of nodes in the GKE cluster
- `gke_max_node_count` - The maximum number of nodes in the GKE cluster
- `redis_memory_size_gb` - The memory size of the redis cluster
- `database_machine_type` - The instance type for the database

## Examples

We have included documentation and reference examples for common
installation scenarios, as well as examples for supporting
resources that lack official modules.

- [Public Instance with HTTPS using Cloud DNS](examples/public-dns-with-cloud-dns)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.30 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.10 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.23 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.11.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.30 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.23 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_gke"></a> [app\_gke](#module\_app\_gke) | ./modules/app_gke | n/a |
| <a name="module_app_lb"></a> [app\_lb](#module\_app\_lb) | ./modules/app_lb | n/a |
| <a name="module_clickhouse"></a> [clickhouse](#module\_clickhouse) | ./modules/clickhouse | n/a |
| <a name="module_cloud_nat"></a> [cloud\_nat](#module\_cloud\_nat) | ./modules/cloud_nat | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_gke_app"></a> [gke\_app](#module\_gke\_app) | wandb/wandb/kubernetes | 1.14.1 |
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/kms | n/a |
| <a name="module_kms_default_bucket"></a> [kms\_default\_bucket](#module\_kms\_default\_bucket) | ./modules/kms | n/a |
| <a name="module_kms_default_sql"></a> [kms\_default\_sql](#module\_kms\_default\_sql) | ./modules/kms | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_private_link"></a> [private\_link](#module\_private\_link) | ./modules/private_link | n/a |
| <a name="module_project_factory_project_services"></a> [project\_factory\_project\_services](#module\_project\_factory\_project\_services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 14.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | ./modules/redis | n/a |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | ./modules/service_accounts | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |
| <a name="module_wandb"></a> [wandb](#module\_wandb) | wandb/wandb/helm | 1.2.0 |

## Resources

| Name | Type |
|------|------|
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [kubernetes_ingress_v1.internal-lb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/ingress_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_inbound_cidrs"></a> [allowed\_inbound\_cidrs](#input\_allowed\_inbound\_cidrs) | Which IPv4 addresses/ranges to allow access. This must be explicitly provided, and by default is set to ["*"] | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_allowed_project_names"></a> [allowed\_project\_names](#input\_allowed\_project\_names) | A map of allowed projects where each key is a project number and the value is the connection limit. | `map(number)` | `{}` | no |
| <a name="input_app_wandb_env"></a> [app\_wandb\_env](#input\_app\_wandb\_env) | Extra environment variables for W&B | `map(string)` | `{}` | no |
| <a name="input_bucket_default_encryption"></a> [bucket\_default\_encryption](#input\_bucket\_default\_encryption) | Boolean to determine if a default bucket encryption key should be used. If true, a default key will be created. Takes precedence over `bucket_kms_key_id`. | `bool` | `false` | no |
| <a name="input_bucket_kms_key_id"></a> [bucket\_kms\_key\_id](#input\_bucket\_kms\_key\_id) | ID of the customer-provided bucket KMS key. | `string` | `null` | no |
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | Location of the bucket (US, EU, ASIA) | `string` | `"US"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Use an existing bucket. | `string` | `""` | no |
| <a name="input_bucket_path"></a> [bucket\_path](#input\_bucket\_path) | path of where to store data for the instance-level bucket | `string` | `""` | no |
| <a name="input_clickhouse_private_endpoint_service_name"></a> [clickhouse\_private\_endpoint\_service\_name](#input\_clickhouse\_private\_endpoint\_service\_name) | ClickHouse private endpoint 'Service name' (ends in -clickhouse-cloud). | `string` | `""` | no |
| <a name="input_clickhouse_region"></a> [clickhouse\_region](#input\_clickhouse\_region) | ClickHouse region (us-east1, us-central1, etc). | `string` | `""` | no |
| <a name="input_clickhouse_subnetwork_cidr"></a> [clickhouse\_subnetwork\_cidr](#input\_clickhouse\_subnetwork\_cidr) | ClickHouse private service connect subnetwork | `string` | `"10.50.0.0/24"` | no |
| <a name="input_controller_image_tag"></a> [controller\_image\_tag](#input\_controller\_image\_tag) | Tag of the controller image to deploy | `string` | `"1.14.0"` | no |
| <a name="input_create_private_link"></a> [create\_private\_link](#input\_create\_private\_link) | Whether to create a private link service. | `bool` | `false` | no |
| <a name="input_create_redis"></a> [create\_redis](#input\_create\_redis) | Boolean indicating whether to provision an redis instance (true) or not (false). | `bool` | `false` | no |
| <a name="input_create_workload_identity"></a> [create\_workload\_identity](#input\_create\_workload\_identity) | Flag to indicate whether to create a workload identity for the service account. | `bool` | `false` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | Flags to set for the database | `map(string)` | `{}` | no |
| <a name="input_database_machine_type"></a> [database\_machine\_type](#input\_database\_machine\_type) | Specifies the machine type to be allocated for the database. Defaults to null and value from deployment-size.tf is used | `string` | `null` | no |
| <a name="input_database_sort_buffer_size"></a> [database\_sort\_buffer\_size](#input\_database\_sort\_buffer\_size) | Specifies the sort\_buffer\_size value to set for the database | `number` | `67108864` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Version for MySQL | `string` | `"MYSQL_8_0_31"` | no |
| <a name="input_db_kms_key_id"></a> [db\_kms\_key\_id](#input\_db\_kms\_key\_id) | ID of the customer-provided SQL KMS key. | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`. | `bool` | `true` | no |
| <a name="input_disable_code_saving"></a> [disable\_code\_saving](#input\_disable\_code\_saving) | Boolean indicating if code saving is disabled | `bool` | `false` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain for accessing the Weights & Biases UI. | `string` | `null` | no |
| <a name="input_enable_private_gke_nodes"></a> [enable\_private\_gke\_nodes](#input\_enable\_private\_gke\_nodes) | Enable private nodes for the GKE cluster. When set to true, nodes will not have public IPs, and Cloud NAT with a static public IP will be used for egress traffic. Ensure sufficient quota for static IPs in the specified region. | `bool` | `false` | no |
| <a name="input_enable_stackdriver"></a> [enable\_stackdriver](#input\_enable\_stackdriver) | n/a | `bool` | `false` | no |
| <a name="input_force_ssl"></a> [force\_ssl](#input\_force\_ssl) | Enforce SSL through the usage of the Cloud SQL Proxy (cloudsql://) in the DB connection string | `bool` | `false` | no |
| <a name="input_gke_machine_type"></a> [gke\_machine\_type](#input\_gke\_machine\_type) | Specifies the machine type for nodes in the GKE cluster. Defaults to null and value from deployment-size.tf is used | `string` | `null` | no |
| <a name="input_gke_max_node_count"></a> [gke\_max\_node\_count](#input\_gke\_max\_node\_count) | Maximum number of nodes for the GKE cluster. Defaults to null and value from deployment-size.tf is used | `number` | `null` | no |
| <a name="input_gke_min_node_count"></a> [gke\_min\_node\_count](#input\_gke\_min\_node\_count) | Initial number of nodes for the GKE cluster, if gke\_max\_node\_count is set, this is the minimum number of nodes. Defaults to null and value from deployment-size.tf is used | `number` | `null` | no |
| <a name="input_ilb_proxynetwork_cidr"></a> [ilb\_proxynetwork\_cidr](#input\_ilb\_proxynetwork\_cidr) | Internal load balancer proxy subnetwork | `string` | `"10.127.0.0/24"` | no |
| <a name="input_kubernetes_cluster_oidc_issuer_url"></a> [kubernetes\_cluster\_oidc\_issuer\_url](#input\_kubernetes\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the Kubernetes cluster. Can be determined using `kubectl get --raw /.well-known/openid-configuration` | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to resources | `map(string)` | `{}` | no |
| <a name="input_license"></a> [license](#input\_license) | Your wandb/local license | `string` | n/a | yes |
| <a name="input_local_restore"></a> [local\_restore](#input\_local\_restore) | Restores W&B to a stable state if needed | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | String used for prefix resources. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Pre-existing network self link | `string` | `null` | no |
| <a name="input_oidc_auth_method"></a> [oidc\_auth\_method](#input\_oidc\_auth\_method) | OIDC auth method | `string` | `"implicit"` | no |
| <a name="input_oidc_client_id"></a> [oidc\_client\_id](#input\_oidc\_client\_id) | The Client ID of application in your identity provider | `string` | `""` | no |
| <a name="input_oidc_issuer"></a> [oidc\_issuer](#input\_oidc\_issuer) | A url to your Open ID Connect identity provider, i.e. https://cognito-idp.us-east-1.amazonaws.com/us-east-1_uiIFNdacd | `string` | `""` | no |
| <a name="input_oidc_secret"></a> [oidc\_secret](#input\_oidc\_secret) | The Client secret of application in your identity provider | `string` | `""` | no |
| <a name="input_operator_chart_version"></a> [operator\_chart\_version](#input\_operator\_chart\_version) | Version of the operator chart to deploy | `string` | `"1.3.4"` | no |
| <a name="input_other_wandb_env"></a> [other\_wandb\_env](#input\_other\_wandb\_env) | Extra environment variables for W&B | `map(string)` | `{}` | no |
| <a name="input_parquet_wandb_env"></a> [parquet\_wandb\_env](#input\_parquet\_wandb\_env) | Extra environment variables for W&B | `map(string)` | `{}` | no |
| <a name="input_psc_subnetwork_cidr"></a> [psc\_subnetwork\_cidr](#input\_psc\_subnetwork\_cidr) | Private link service reserved subnetwork | `string` | `"192.168.0.0/24"` | no |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Whether to create a public endpoint for wandb access. | `bool` | `true` | no |
| <a name="input_redis_memory_size_gb"></a> [redis\_memory\_size\_gb](#input\_redis\_memory\_size\_gb) | Specifies the memory size in GB for the Redis instance. Defaults to null and value from deployment-size.tf is used | `number` | `null` | no |
| <a name="input_redis_reserved_ip_range"></a> [redis\_reserved\_ip\_range](#input\_redis\_reserved\_ip\_range) | Reserved IP range for REDIS peering connection | `string` | `"10.30.0.0/16"` | no |
| <a name="input_redis_tier"></a> [redis\_tier](#input\_redis\_tier) | Specifies the tier for this Redis instance | `string` | `"STANDARD_HA"` | no |
| <a name="input_resource_limits"></a> [resource\_limits](#input\_resource\_limits) | Specifies the resource limits for the wandb deployment | `map(string)` | <pre>{<br/>  "cpu": null,<br/>  "memory": null<br/>}</pre> | no |
| <a name="input_resource_requests"></a> [resource\_requests](#input\_resource\_requests) | Specifies the resource requests for the wandb deployment | `map(string)` | <pre>{<br/>  "cpu": "2000m",<br/>  "memory": "2G"<br/>}</pre> | no |
| <a name="input_size"></a> [size](#input\_size) | Deployment size for the instance | `string` | `"small"` | no |
| <a name="input_skip_bucket_admin_role"></a> [skip\_bucket\_admin\_role](#input\_skip\_bucket\_admin\_role) | Flag to indicate whether to skip the bucket policy creation. | `bool` | `false` | no |
| <a name="input_sql_default_encryption"></a> [sql\_default\_encryption](#input\_sql\_default\_encryption) | Boolean to determine if a default SQL encryption key should be used. If true, a default key will be created. Takes precedence over `db_kms_key_id`. | `bool` | `false` | no |
| <a name="input_ssl"></a> [ssl](#input\_ssl) | Enable SSL certificate | `bool` | `true` | no |
| <a name="input_stackdriver_sa_name"></a> [stackdriver\_sa\_name](#input\_stackdriver\_sa\_name) | n/a | `string` | `"wandb-stackdriver"` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route. | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Pre-existing subnetwork self link | `string` | `null` | no |
| <a name="input_use_internal_queue"></a> [use\_internal\_queue](#input\_use\_internal\_queue) | Uses an internal redis queue instead of using google pubsub. | `bool` | `false` | no |
| <a name="input_wandb_image"></a> [wandb\_image](#input\_wandb\_image) | Docker repository of to pull the wandb image from. | `string` | `"wandb/local"` | no |
| <a name="input_wandb_version"></a> [wandb\_version](#input\_wandb\_version) | The version of Weights & Biases local to deploy. | `string` | `"latest"` | no |
| <a name="input_weave_wandb_env"></a> [weave\_wandb\_env](#input\_weave\_wandb\_env) | Extra environment variables for W&B | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | n/a |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of google bucket. |
| <a name="output_bucket_path"></a> [bucket\_path](#output\_bucket\_path) | path of where to store data for the instance-level bucket |
| <a name="output_bucket_queue_name"></a> [bucket\_queue\_name](#output\_bucket\_queue\_name) | Pubsub queue created for google bucket file upload events. |
| <a name="output_clickhouse_private_endpoint_id"></a> [clickhouse\_private\_endpoint\_id](#output\_clickhouse\_private\_endpoint\_id) | ClickHouse Private endpoint Endpoint ID to secure access inside VPC |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Certificate of the kubernetes (GKE) cluster. |
| <a name="output_cluster_client_certificate"></a> [cluster\_client\_certificate](#output\_cluster\_client\_certificate) | n/a |
| <a name="output_cluster_client_key"></a> [cluster\_client\_key](#output\_cluster\_client\_key) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint of the kubernetes (GKE) cluster. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the kubernetes (GKE) cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_node_pool"></a> [cluster\_node\_pool](#output\_cluster\_node\_pool) | Default node pool where Weights & Biases should be deployed into. |
| <a name="output_cluster_self_link"></a> [cluster\_self\_link](#output\_cluster\_self\_link) | Self link of the kubernetes (GKE) cluster. |
| <a name="output_database_connection_string"></a> [database\_connection\_string](#output\_database\_connection\_string) | Full database connection string. You must be in the VPC to access the database. |
| <a name="output_database_instance_type"></a> [database\_instance\_type](#output\_database\_instance\_type) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The FQDN to the W&B application |
| <a name="output_gke_max_node_count"></a> [gke\_max\_node\_count](#output\_gke\_max\_node\_count) | n/a |
| <a name="output_gke_node_count"></a> [gke\_node\_count](#output\_gke\_node\_count) | n/a |
| <a name="output_gke_node_instance_type"></a> [gke\_node\_instance\_type](#output\_gke\_node\_instance\_type) | n/a |
| <a name="output_private_attachement_id"></a> [private\_attachement\_id](#output\_private\_attachement\_id) | n/a |
| <a name="output_sa_account_email"></a> [sa\_account\_email](#output\_sa\_account\_email) | This output provides the email address of the service account created for workload identity, if workload identity is enabled. Otherwise, it returns null |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Weights & Biases service account used to manage resources. |
| <a name="output_standardized_size"></a> [standardized\_size](#output\_standardized\_size) | n/a |
| <a name="output_url"></a> [url](#output\_url) | The URL to the W&B application |
<!-- END_TF_DOCS -->

## Migrations

### 5.x -> 6.x

6.0.0 introduced autoscaling to the GKE cluster and made the `size` variable the preferred way to set the cluster size.
Previously, unless the `size` variable was set explicitly, there were default values for the following variables:
- `gke_machine_type`
- `gke_node_count`
- `redis_memory_size_gb`
- `db_machine_type`  

The `size` variable is now defaulted to `small`, and the following values to can be used to partially override the values
set by the `size` variable:
- `gke_machine_type`
- `gke_min_node_count`
- `gke_max_node_count`
- `redis_memory_size_gb`
- `database_machine_type`

For more information on the available sizes, see the [Cluster Sizing](#cluster-sizing) section.

If having the cluster scale nodes in and out is not desired, the `gke_min_node_count` and `gke_max_node_count` can be set
to the same value to prevent the cluster from scaling.

### 3.x -> 4.x 

3.6.0 introduced a change in the Google Provider that isn't backwards compatible with prior versions. 
Nothing needs to be done to upgrade, but it is not backwards compatible. 
