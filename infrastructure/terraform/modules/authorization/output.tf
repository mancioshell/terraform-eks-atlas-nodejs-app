output "cloudfront_domain_name" {
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.cognito_static_website.id
}

output "api_gateway_base_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}
