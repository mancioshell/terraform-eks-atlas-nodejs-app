terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.79"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = ">=1.36.0"
    }
  }
}
