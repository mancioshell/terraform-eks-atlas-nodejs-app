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
      version = ">= 5.79"
    }

    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = ">=1.36.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.37.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
  }
}
