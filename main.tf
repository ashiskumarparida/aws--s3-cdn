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
resource "aws_cloudfront_distribution" "ashis" {
  origin {
    domain_name = "aws_s3_bucket.aktk.https://d28ltohlixkpbu.cloudfront.net"
    origin_id   = "aktk.s3.ap-south-1.amazonaws.com"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3UTFGUW2TQQJJ"
    }
  }

  depends_on = [
    aws_cloudfront_distribution.ashis
  ]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "aktk.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["https://d28ltohlixkpbu.cloudfront.net"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "aktk.s3.ap-south-1.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 5
    max_ttl                = 10
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "aktk.s3.ap-south-1.amazonaws.com"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 5
    max_ttl                = 10
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "aktk.s3.ap-south-1.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 5
    max_ttl                = 10
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}