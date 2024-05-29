terraform {
  required_version = ">= 0.14"

  cloud {
    organization = "weights-and-biases"

    workspaces {
      name = "terraform-google-wandb-public-dns"
    }
  }
}