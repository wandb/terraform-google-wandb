# Deploy a W&B with a domain that uses GCP Cloud DNS as the DNS service

## About

This example is a minimal example of what is needed to deploy an instance of
Weights & Biases that uses a Domain hosted in Route53.

## Module Prerequisites

As with the main version of this module, this example assumes the following
resources already exist:

- A valid Cloud DNS for the provided domain
- Valid W&B Local license (You get one at [here](https://deploy.wandb.ai))

### Downloading Terraform

- You can download terraform by following one of the methods here[[https://www.terraform.io/downloads](https://www.terraform.io/downloads)]
- The required version of terraform for this module is v1.1.7 or greater
- If you operate with multiple terraforms, `tfenv` is a great tool that allows switching between different terraform versions

### Using an existing domain
- If you already have an existing domain, you could create a sub-domain for that domain and use that for W&B.
- If you don't have an existing domain, please see below on how to create one

### Setting up a google domain

- Navigate to Cloud DNS from the GCP console
- Then, click on `Create Zone`
- Enter your Zone name and DNS name
- Click `Create`

### Setting up a google sub-domain

- Once you’ve created a zone & DNS in the above step, click on that Zone name
- Click on `Add Record Set`
- Add your sub-domain in the DNS name field
- You can choose to leave the defaults for Resource Record Set, TTL and Routing Policy
- Add the IPv4 Address (you’ll get this as an output of `terraform apply`)
- Then click `Create`

Note: The domain and subdomain association might take a few minutes to reflect.

### Getting the ID of a project in GCP

- Once you login to the GCP dashboard, you should see an option similar to the following image
  ![gcp-project-name](https://user-images.githubusercontent.com/92930965/166116107-019bad40-bf9c-4666-96e3-04e4512dab4b.png)
- Click on the Project name, in this case it’s WandB Sandbox
- This will open a dialog similar to this
  ![gcp-project-id](https://user-images.githubusercontent.com/92930965/166116122-e7882c85-2024-447c-ad3c-2bd1df4dad17.png)
- You can find the ID of the project here, in this case `playground-111`

### Setting the region and zone in GCP

- Firstly, identify the region you’d like to deploy the W&B application
- A list of all the regions and zones available in GCP can be found here[[https://cloud.google.com/compute/docs/regions-zones](https://cloud.google.com/compute/docs/regions-zones)]
- Once you’ve identified the region and the zone, make sure to input the name in the same format into the `terraform.tfvars` file below

### Setting the stage

- First authorize your google account by running the command `gcloud auth login`
  - This would take you to the browser to select the google account to authenticate with GCP
  - Once the google account is selected and authorized, you should see a message similar to:
    ```markdown
    You are now logged in as [venkata@wandb.com].
    Your current project is [playground-111]. You can change this setting by running:
    $ gcloud config set project PROJECT_ID

    Updates are available for some Cloud SDK components. To install them,
    please run:
    $ gcloud components update

    To take a quick anonymous survey, run:
    $ gcloud survey
    ```
- Clone the [Github repository](https://github.com/wandb/terraform-google-wandb) to get access to the W&B’s google terraform module
- As a next step, navigate to the examples directory in the [terraform-google-wandb](https://github.com/wandb/terraform-google-wandb/tree/main/examples) repo
  - Then, `cd public-dns-with-cloud-dns`
- Now, create a file called `terraform.tfvars` under the current directory
- `terraform.tfvars` should have the following variables included,
  ```markdown
  project_id            = "<id-of-the-project-in-gcp>"
  region                = "<gcp-region-to-deploy>"
  zone                  = "<gcp-zone-to-deploy>"
  namespace             = "<unique-name-for-the-namespace>"
  license               = "<W&B-license-key>"
  subdomain             = "<subdomain-for-accessing-the-UI>"
  domain_name           = "<domain-for-accessing-the-UI>"
  allowed_inbound_cidrs = ["<allowed ip ranges>"]
  ```
  Refer to sections above to see how you can obtain these values
  An example `terraform.tfvars` file would look like this,
  ```markdown
  project_id            = "playground-111"
  region                = "us-west4"
  zone                  = "us-west4-a"
  namespace             = "venky-unique-3"
  license               = "eyJhbGciOiJS6InUzhEUXM1M0xQY09yNnZhaTdoSlduYnF1bTRZTlZWd1VwSWM9In0.eyJjb25jdXJyZW50QWdlbnRzIjoxMCwiZGVwbG95bWVudElkIjoiNGU0YWNiZmYtY2E5NS00MmRiLThmYmItMjliNmY5NTI2OWE0IiwibWF4VXNlcnMiOjQsIm1heFN0b3JhZ2VHYiI6MTAwMDAwMCwibWF4VGVhbXMiOjEsImV4cGlyZXNBdCI6IjIwMjItMTAtMjBUMTY6MjY6NTUuNzA3WiIsImZsYWdzIjpbIlNDQUxBQkxFIiwibXlzcWwiLCJzMyIsInJlZGlzIiwiTk9USUZJQ0FUSU9OUyIsInNsYWNrIiwibm90aWZpY2F0aW9ucyIsIk1BTkFHRU1FTlQiLCJvcmdfZGFzaCIsImF1dGgwIl0sInRyaWFsIjpmYWxzZSwiYWNjZXNzS2V5IjoiNzk3M2FkOWItNThmOC00OTUxLWJhOTctOGQ2NGFkYzI1ZThlIiwic2VhdHMiOjQsInRlYW1zIjoxLCJzdG9yYWdlR2lncyI6MTAwMDAwMCwiZXhwIjoxNjY2MjgzMjE1fQ.O_6D3Av9QoWI16ybg54KFvs7eGWugSXPxmfhobtZe3TBFvd8PwmSCAmMojmKWsqg6KNjLJ9sjxOP_3Pj9OAdrkx5WzU0KTcIByXD2hS9VwyYUOYEohBn65oCLnQJLYphXJBrB9JVS0GSUGxR1AzwnUK1PuKZ6jQFrpt-feQOD3rvCdyM1eBQ73rdHk6zfEBmdiZ7C4LiRLV8OEMxUfwxASvVF_cFUEeVQx82AaxRwfPBLZxXTL4qlQOIFjAKwGVyDMEWq04BhQ_ASdyND45w5qXiUOlvFOergrFyGBSHg-9yDT4fhdkDw5puGthDaMFsn02rr0eYHuxKFWSY958aig"
  subdomain             = "venky"
  domain_name           = "wandb.ml"
  allowed_inbound_cidrs = ["0.0.0.0/0"]
  ```

### Initializing the terraform

- First step is to initialize the terraform module in the current directory, you can do that by running

```markdown
terraform init
```

This initializes all the required modules to successfully deploy the W&B infrastructure

- If you are running into an error like `Error: Failed to query available provider packages` just run the following command:

```markdown
terraform init -upgrade
```

This makes sure all the terraform initialization version requirements are satisfied by downloading the latest terraform module versions

### Running the terraform

- Once the terraform is initialized and you have all the values set in the `terraform.tfvars` , you should be able to apply the terraform by running the following command:

```markdown
terraform apply
```

- This will output a plan of all the resources to be created by terraform in your GCP account
- The terminal prompts to enter `yes`, if you intend to continue
- Once you input `yes` the terraform creation process begins
- It takes ~10 minutes to create all the resources
