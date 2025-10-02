# ################################################################################
# # VPC Module
# ################################################################################

module "vpc" {
  source     = "./modules/vpc"
  aws-region = var.aws-region
}


# ################################################################################
# # EKS Cluster Module
# ################################################################################

module "eks" {
  source = "./modules/eks-cluster"

  aws-region   = var.aws-region
  cluster_name = var.cluster_name

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}