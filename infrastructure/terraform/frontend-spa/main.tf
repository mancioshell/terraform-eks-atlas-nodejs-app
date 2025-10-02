################################################################################
# Authorization Module
################################################################################

module "authorization" {
  source          = "./modules/authorization"
  aws-region      = var.aws-region
  nlb-arn         = data.aws_lb.nlb.arn
  load_balancer_dns = data.aws_lb.nlb.dns_name
}


data "aws_lb" "nlb" {
  tags = {
    Environment = "dev"
    Owner       = "terraform"
  }
}
