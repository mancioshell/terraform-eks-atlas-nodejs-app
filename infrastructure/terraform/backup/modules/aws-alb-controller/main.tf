# ################################################################################
# # IAM Module
# ################################################################################

module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "6.2.1"
}

################################################################################
# Load Balancer Role
################################################################################

module "irsa" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name                                   = "${var.env_name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  depends_on = [var.oidc_provider_arn]
}


################################################################################
# Aws Load balancer Controller Service Account
################################################################################

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.irsa.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }

  depends_on = [var.cluster_certificate_authority_data, var.cluster_endpoint, module.iam]
}

################################################################################
# Install Load Balancer Controler With Helm
################################################################################

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account, var.vpc_id
  ]

  set = [{
    name  = "region"
    value = var.aws-region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.${var.aws-region}.amazonaws.com/amazon/aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "clusterName"
      value = var.cluster_name
    }
  ]

}
