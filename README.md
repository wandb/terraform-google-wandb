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

### Terrafom version >= 1h

### Credentials / Permissions

**AWS Services Used**

- SQL Cloud (MySQL)
- Kubernetes
- Cloud DNS

### Public Hosted Zone

If you are managing DNS via Cloud DNS the hosted zone entry is created
automatically as part of your domain management.

## How to Use This Module

- Ensure account meets module pre-requisites from above.
- Please note that while some resources are individually and uniquely tagged,
  all common tags are expected to be configured within the AWS provider as shown
  in the example code snippet below.

- Create a Terraform configuration that pulls in this module and specifies
  values of the required variables:

```hcl
provider "aws" {
  region = "<your AWS region>"
  default_tags {
    tags = var.common_tags
  }
}

module "wandb" {
  source    = "<filepath to cloned module directory>"
  namespace = "<prefix for naming AWS resources>"
}
```

- Run `terraform init` and `terraform apply`

## Examples

We have included documentation and reference examples for additional common
installation scenarios for Weights & Biases, as well as examples for supporting
resources that lack official modules.

<!-- BEGIN_TF_DOCS -->
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
