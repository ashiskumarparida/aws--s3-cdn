provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA4QX4AMYS4TPYZGNN"
  secret_key = "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"
}
terraform {
  backend "s3" {
    bucket = "aktk"
    region = "ap-south-1"
  }
}
resource "aws_s3_bucket" "akbackend" {
  bucket = "akbackend"
}
#  resource "aws_s3_bucket_acl" "aktk" {
#   bucket = "aktk"
#   acl    = "private"
#   }

resource "aws_cloudfront_distribution" "ak" {
  origin {
    domain_name = aws_s3_bucket.default.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.default.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }
}
# enabled             = true
# is_ipv6_enabled     = false
# default_root_object = "index.html"

# aliases = [var.bucket_name]

# default_cache_behavior {
#  allowed_methods  = ["GET", "HEAD"]
#  cached_methods   = ["GET", "HEAD"]
#  target_origin_id = "S3-${aws_s3_bucket.default.id}"

#  forwarded_values {
#    query_string = false
#
#    cookies {
#      forward = "none"
#    }
#  }
#  viewer_protocol_policy = "redirect-to-https"
#  min_ttl                = 0
#  default_ttl            = 0
#  max_ttl                = 0

#  lambda_function_association {
#    event_type   = "origin-request"
#    include_body = false
#    lambda_arn   = "arn:aws:lambda:us-east-1:225237029829:function:s3-cdn:2"
#  }
