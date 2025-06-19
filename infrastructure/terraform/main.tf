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


# ################################################################################
# # AWS ALB Controller
# ################################################################################

module "aws_alb_controller" {
  source = "./modules/aws-alb-controller"

  aws-region   = var.aws-region
  env_name     = var.env_name
  cluster_name = var.cluster_name

  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
}


################################################################################
# MongoDB Atlas Cluster Module
################################################################################

module "atlas_cluster" {
  source = "./modules/atlas-cluster"

  atlas_org_id                   = var.atlas_org_id
  atlas_public_key               = var.atlas_public_key
  atlas_private_key              = var.atlas_private_key

  atlas_db_username              = var.atlas_db_username
  atlas_db_password              = var.atlas_db_password

  project_name                   = var.atlas_project_name
  cluster_name                   = var.atlas_cluster_name
  cluster_type                   = var.atlas_cluster_type
  provider_name                  = var.atlas_provider_name
  backing_provider_name          = var.atlas_backing_provider_name
  backing_provider_region_name   = var.aws-region
  provider_instance_size_name    = var.atlas_provider_instance_size_name

  vpc_id                         = module.vpc.vpc_id
}