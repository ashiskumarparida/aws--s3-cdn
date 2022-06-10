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
