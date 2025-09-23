data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_auth_lambda_project"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_role_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_logs_role_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_lambda_permission" "api-gateway-invoke-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth-lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.auth-api.execution_arn}/*/*"
}


data "archive_file" "auth-lambda" {
  type        = "zip"
  source_file = "${path.module}/../../../dist/index.js"
  output_path = "${path.module}/../../../dist/lambda.zip"
}

resource "aws_lambda_function" "auth-lambda" {
  function_name    = "auth-lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = data.archive_file.auth-lambda.output_path
  handler          = "index.handler"
  source_code_hash = data.archive_file.auth-lambda.output_base64sha256
  runtime          = "nodejs22.x"
  timeout          = 60

  environment {
    variables = {
      ENVIRONMENT          = "dev"
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.pool.id
      COGNITO_REGION       = var.aws-region
    }
  }
}
