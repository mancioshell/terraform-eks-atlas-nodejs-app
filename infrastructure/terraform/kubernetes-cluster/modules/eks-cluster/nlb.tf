# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress-controller"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.10.0"

#   namespace        = "ingress-nginx"
#   create_namespace = true

#   values = [
#     <<EOF
# controller:
#   service:
#     type: LoadBalancer
#     targetPorts:
#       http: http
#       https: http 
#     annotations:
#       service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
#       service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
#       service.beta.kubernetes.io/aws-load-balancer-type: nlb
#       service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
#       service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy: 'ELBSecurityPolicy-TLS13-1-2-2021-06'
#       service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
#       # opzionale: taggatura delle risorse AWS generate
#       service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: "Environment=dev,Owner=terraform"
# EOF
#   ]
# }