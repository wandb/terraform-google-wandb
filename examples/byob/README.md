# Bring Your Own Bucket (BYOB)

## About

Weights & Biases can connect to a GCP Bucket created and owned by the customer. This is called BYOB (Bring your own bucket). More details (here)[https://docs.wandb.ai/guides/hosting/data-security/secure-storage-connector#provision-the-gcs-bucket].

This example does not deploy a Weights & Biases instance. It deploys all required resources (GCP bucket and permissions) in the customer's account and grants the W&B GCP Service Account access to the bucket.

---

## Using Terraform

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

## Using the GCP Console

Please refer to the (public documentation)[https://docs.wandb.ai/guides/hosting/data-security/secure-storage-connector#provision-the-gcs-bucket] on how to create all required resources manually.
