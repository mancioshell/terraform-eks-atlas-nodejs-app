# resource "aws_lb" "network" {
#   name = var.nlb_name

#   load_balancer_type = "network"

#   internal = true
#   subnets  = module.vpc.private_subnets

#   tags = {
#     Environment = "production"
#   }
# }

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"

  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
      service.beta.kubernetes.io/aws-load-balancer-ip-address-type: "ipv4"
      # opzionale: taggatura delle risorse AWS generate
      service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: "Environment=dev,Owner=terraform,Project=eks-cluster"
EOF
  ]
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "ingress-nginx"
  }
}



data "aws_lb" "nlb" {
  name = split("-", split(".", data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.hostname).0).1
}
