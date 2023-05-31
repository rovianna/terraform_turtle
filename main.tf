provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket" {
    bucket = "mask-amino"
    acl = "private"
}