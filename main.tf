provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket" {
    bucket = "mask-amino"
    acl = "private"
}

resource "null_resource" "upload_file" {
    provisioner "local-exec" {
      command = "aws s3 cp ./consolidade_med.csv s3://${aws_s3_bucket.data_bucket.bucket}/consolidado_med.csv"
    }

    depends_on = [ aws_s3_bucket.data_bucket ]
}