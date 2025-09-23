resource "aws_s3_bucket" "cognito_static_website" {
  bucket        = "static-website-cognito-auth-spa"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "static_website_configuration" {
  bucket = aws_s3_bucket.cognito_static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_one_public_access_policy" {
  bucket = aws_s3_bucket.cognito_static_website.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cognito_static_website.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.cognito_static_website]
}

resource "aws_s3_bucket_public_access_block" "cognito_static_website" {
  bucket                  = aws_s3_bucket.cognito_static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
