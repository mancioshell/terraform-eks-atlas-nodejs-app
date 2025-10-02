resource "aws_cognito_user_pool" "pool" {

  name = "app-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]


  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id                 = aws_cognito_user_pool.pool.id
  generate_secret              = false
  supported_identity_providers = ["COGNITO"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [
    "code"
  ]
  allowed_oauth_scopes = ["email", "openid", "phone"]

  explicit_auth_flows = [
    "ALLOW_USER_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  callback_urls = [
    "https://${aws_cloudfront_distribution.cdn.domain_name}"
  ]

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }

  access_token_validity  = 1
  id_token_validity      = 1
  refresh_token_validity = 5

  enable_token_revocation = true

  prevent_user_existence_errors = "ENABLED"

}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "nodejs-app-user-pool-domain-yz"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.pool.id

  username = "user@example.com"
  password = "P@ssw0rd123!"

  attributes = {
    email = "user@example.com"
  }

  force_alias_creation = false
  message_action       = "SUPPRESS"

  depends_on = [
    aws_cognito_user_pool.pool
  ]

}
