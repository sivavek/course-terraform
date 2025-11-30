resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "terraform-course-1-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "static_website_bucket" {
  bucket                  = aws_s3_bucket.static_website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_bucket_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website_bucket.arn}/*"
      }
    ]
  })

}

resource "aws_s3_bucket_website_configuration" "static_website_bucket_config" {
  bucket = aws_s3_bucket.static_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = "index.html"
  source       = "${path.module}/build/index.html"
  etag         = filemd5("${path.module}/build/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = "error.html"
  source       = "${path.module}/build/error.html"
  etag         = filemd5("${path.module}/build/error.html")
  content_type = "text/html"
}

output "bucket_public_url" {
  description = "Public URL for the S3 static website bucket"
  value       = aws_s3_bucket_website_configuration.static_website_bucket_config.website_endpoint
}