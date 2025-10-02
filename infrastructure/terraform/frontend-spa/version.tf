terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mancioshell"

    workspaces {
      name = "frontend-spa-dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.14.0"
    }
  }
}
