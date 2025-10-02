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

resource "aws_lambda_permission" "api-gateway-invoke-lambda-authorizer" {
  statement_id  = "AllowAPIGatewayInvoke_authorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_authorizer.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.api-gw.execution_arn}/*/*"
}

data "archive_file" "lambda_authorizer" {
  type        = "zip"
  source_file = "${path.module}/lambda-authorizer/dist/lambda.js"
  output_path = "${path.module}/lambda-authorizer/lambda.zip"
}

resource "aws_lambda_function" "lambda_authorizer" {
  function_name    = "lambda_authorizer"
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = data.archive_file.lambda_authorizer.output_path
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.lambda_authorizer.output_base64sha256
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
