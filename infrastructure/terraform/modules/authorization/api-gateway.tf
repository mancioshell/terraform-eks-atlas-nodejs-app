# API Gateway
resource "aws_api_gateway_rest_api" "api-gw" {
  name        = "api-gw"
  description = "Auth API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway root resource
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  parent_id   = aws_api_gateway_rest_api.api-gw.root_resource_id
  path_part   = "{proxy+}"
}


# Lambda Authorizer
resource "aws_api_gateway_authorizer" "cognito_custom_authorizer" {
  name                             = "cognito_custom_authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.api-gw.id
  authorizer_uri                   = aws_lambda_function.lambda_authorizer.invoke_arn
#  authorizer_credentials = aws_iam_role.invocation_role.arn
  authorizer_result_ttl_in_seconds = 0
}

# data "aws_iam_policy_document" "invocation_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["apigateway.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "invocation_role" {
#   name               = "api_gateway_auth_invocation"
#   path               = "/"
#   assume_role_policy = data.aws_iam_policy_document.invocation_assume_role.json
# }

# data "aws_iam_policy_document" "invocation_policy" {
#   statement {
#     effect    = "Allow"
#     actions   = ["lambda:InvokeFunction"]
#     resources = [aws_lambda_function.lambda_authorizer.arn]
#   }
# }


# resource "aws_iam_role_policy" "invocation_policy" {
#   name   = "default"
#   role   = aws_iam_role.invocation_role.id
#   policy = data.aws_iam_policy_document.invocation_policy.json
# }

// OPTIONS method for CORS

resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.api-gw.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api-gw.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 204}"
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "204"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type, Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration,
  ]
}


# API Gateway Method and Integration

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api-gw.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.cognito_custom_authorizer.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api-gw.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_proxy.invoke_arn
}

resource "aws_api_gateway_deployment" "v1" {

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.root,
      aws_api_gateway_method.proxy,
      aws_api_gateway_integration.lambda_integration,
    ]))
  }

  rest_api_id = aws_api_gateway_rest_api.api-gw.id
}


resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.v1.id
  rest_api_id   = aws_api_gateway_rest_api.api-gw.id
  stage_name    = "v1"

  depends_on = [
    aws_cloudwatch_log_group.api_gateway_execution_logs,
    aws_api_gateway_account.demo
  ]

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_execution_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  stage_name  = aws_api_gateway_stage.v1.stage_name
  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    data_trace_enabled = true
    metrics_enabled    = true
  }
}

data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "api_gateway_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role.json
}

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_cloudwatch_log_group" "api_gateway_execution_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api-gw.id}/v1"
  retention_in_days = 7
}
