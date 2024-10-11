# Weights & Biases Secure Storage Connector Module

## About

Weights & Biases can connect to a GCP Bucket created and owned by the customer. This is called BYOB (Bring your own bucket). More details (here)[https://docs.wandb.ai/guides/hosting/data-security/secure-storage-connector#provision-the-gcs-bucket].

This example does not deploy a Weights & Biases instance. It deploys all required resources (GCP bucket and permissions) in the customer's account and grants the W&B GCP Service Account access to the bucket.

---

## Using Terraform

This is a Terraform module for provisioning a google cloud storage bucket to be used with Weights and Biases. To use this bucket 
with Weights and Biases multi-tenant cloud, pass `wandb-integration@wandb-production.iam.gserviceaccount.com` for the
`service_account_email` variable.

**Google Services Used**

- Google Storage Bucket

### How to Use This Module

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
  source                = "wandb/wandb/google//modules/secure_storage_connector"
  namespace             = "<prefix for naming google resources>"
  service_account_email = "<service account that will access the bucket>"
}
```

- Run `terraform init` and `terraform apply`

<!-- BEGIN_TF_DOCS -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.31 |

### Providers

| Name                                                      | Version |
|-----------------------------------------------------------|---------|
| <a name="provider_google"></a> [google](#provider_google) | 4.31    |

### Inputs

| Name                                                                                             | Description                                            | Type     | Default | Required |
|--------------------------------------------------------------------------------------------------|--------------------------------------------------------|----------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input_namespace)                                     | The prefix to use when creating resources.             | `string` | `null`  |   yes    |
| <a name="input_labels"></a> [labels](#input_labels)                                              | Labels to apply to any resources created               | `map`    | `{}`    |    no    |
| <a name="input_bucket_location"></a> [bucket_location](#input_bucket_location)                   | The location of the bucket (US, EU, ASIA)              | `string` | `US`    |    no    |
| <a name="input_service_account_email"></a> [service_account_email](#input_service_account_email) | The service account that can access the bucket         | `string` | `null`  |   yes    |
| <a name="input_deletion_protection"></a> [wandb_deletion_protection](#input_deletion_protection) | If deletion protection should be enabled on the bucket | `bool`   | `false` |    no    |

### Outputs

| Name                                                                        | Description                                                             |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------|
| <a name="bucket_name"></a> [bucket_name](#bucket_name)                      | The name of the bucket created                                          |

<!-- END_TF_DOCS -->


## Using the GCP Console

Please refer to the (public documentation)[https://docs.wandb.ai/guides/hosting/data-security/secure-storage-connector#provision-the-gcs-bucket] on how to create all required resources manually.
