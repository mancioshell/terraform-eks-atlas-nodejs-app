################################################################################
# Global
################################################################################

output "aws-region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws-region
}

# ################################################################################
# # Authorization
# ################################################################################

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.authorization.cloudfront_domain_name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for static website hosting"
  value       = module.authorization.s3_bucket_name
}

output "api_gateway_base_url" {
  description = "The base URL of the API Gateway"
  value       = module.authorization.api_gateway_base_url
}

output "cognito_client_id" {
  description = "The client ID of the Cognito user pool client"
  value       = module.authorization.cognito_client_id
}

output "cognito_user_pool_id" {
  description = "The ID of the Cognito user pool"
  value       = module.authorization.cognito_user_pool_id
}

output "nlb_arn" {
  description = "The ARN of the Network Load Balancer"
  value       = data.aws_lb.nlb.arn
}
