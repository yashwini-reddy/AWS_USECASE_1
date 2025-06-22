provider "aws" {
  region = "ap-south-1" # Or your desired AWS region
}

resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "my-bucket-static-website-hosting-usecase" # Unique bucket name

  website {
    index_document = "index.html"
  }

  tags = {
    Project     = "StaticWebsiteDeployment"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "static_website_bucket_public_access_block" {
  bucket = aws_s3_bucket.static_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_bucket_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": [
          "${aws_s3_bucket.static_website_bucket.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.static_website_bucket_public_access_block]
}
