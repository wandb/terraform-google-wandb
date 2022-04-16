# Bring Your Own Bucket (BYOB)

This example does not deploy an instance of Weights & Biases. It creates a
google bucket configured for support managed single tenant installs.

---

When using bring your own bucket you will need to grant our service account
access to an google bucket provisioned in project account.

## Provision Bucket using Terraform

1. Install [Terraform
   1.0+](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started)
2. Authenticate with GCP. The easiest way to do this is to run `gcloud auth
   application-default login`, if you already have gcloud installed. If you
   don't already have it, you can install it from
   [here](https://cloud.google.com/sdk/docs/install).
   > Please make sure the
   > account you are using has permission to create a
   > google storage buckets and can set IAM permissions on the created bucket.
3. Clone this repo repository
4. Change your working directly to this folder `cd examples/byob`
5. Run `terraform init`
6. Run `terraform apply`
7. Fill out any required information and approve.
8. Please provide the resulting output to customer support.

## Provision Bucket Manually

_WIP_
