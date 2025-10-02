terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mancioshell"

    workspaces {
      name = "atlas-cluster-dev"
    }
  }

  required_providers {  

    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = ">= 2.0.0"
    }

  }
}
