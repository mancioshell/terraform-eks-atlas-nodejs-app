terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mancioshell"

    workspaces {
      name = "simple-nodejs-app"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.14.0"
    }

    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = ">= 2.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.2"
    }
  }
}
