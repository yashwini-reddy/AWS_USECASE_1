output "website_endpoint" {
  value       = aws_s3_bucket.static_website_bucket.website_endpoint
  description = "URL of the static website hosted on S3"
}
