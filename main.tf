terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "day2_site" {
  bucket = "sandeep-69lpa-day2"
}

resource "aws_s3_bucket_website_configuration" "day2_site" {
  bucket = aws_s3_bucket.day2_site.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "day2_site_public" {
  bucket = aws_s3_bucket.day2_site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.day2_site.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.day2_site.id
  key          = "index.html"
  content      = "<h1>Sandeep Day2 Done - Terraform S3 - 69LPA Loading...</h1>"
  content_type = "text/html"
}