provider "aws" {
  region = var.aws-region
}

provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}

provider "kubernetes" {
  host                   = length(module.eks) > 0 ? module.eks[0].cluster_endpoint : null
  cluster_ca_certificate = length(module.eks) > 0 ? base64decode(module.eks[0].cluster_certificate_authority_data) : null
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  kubernetes = {
    host                   = length(module.eks) > 0 ? module.eks[0].cluster_endpoint : null
    cluster_ca_certificate = length(module.eks) > 0 ? base64decode(module.eks[0].cluster_certificate_authority_data) : null
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}
