################################################################################
# EKS Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"
  create_kms_key              = false
  create_cloudwatch_log_group = false

  encryption_config           = null

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # addons = {
  #   coredns = {}
  #   eks-pod-identity-agent = {
  #     before_compute = true
  #   }
  #   kube-proxy = {}
  #   vpc-cni = {
  #     before_compute = true
  #   }
  # }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  #enable_irsa                              = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  #control_plane_subnet_ids = var.private_subnets

  # # EKS Managed Node Group(s)
  # eks_managed_node_groups = {
  #   example = {
  #     # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
  #     instance_types = ["t3.medium"]

  #     min_size     = 1
  #     max_size     = 2
  #     desired_size = 1
  #   }
  # }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
