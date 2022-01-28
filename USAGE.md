<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_gke"></a> [app\_gke](#module\_app\_gke) | ./modules/app_gke | n/a |
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
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the instance should have deletion protection enabled. The database / Bucket can't be deleted when this value is set to `true`. | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain for accessing the Weights & Biases UI. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to resources | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | String used for prefix resources. | `string` | n/a | yes |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain for accessing the Weights & Biases UI. Default creates record at Route53 Route. | `string` | `null` | no |
| <a name="input_use_internal_queue"></a> [use\_internal\_queue](#input\_use\_internal\_queue) | Uses an internal redis queue instead of using google pubsub. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
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