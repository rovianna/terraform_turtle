provider "aws" {
  region = "us-east-1"
}

resource "null_resource" "run_python_script" {
  provisioner "local-exec" {
    command = "python ./upload_sheets.py"
  }
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "mask-amino"
  acl    = "private"
}

resource "aws_ses_email_identity" "from_address" {
  email = "rodrigogvianna@outlook.com"
}

resource "aws_ses_template" "email_template" {
  name = "Data"
  subject = "Arquivo CSV"
  html = "<html><body> Segue em anexo csv. </body></html>"
  text = "Segue em anexo csv."
}

resource "aws_ses_receipt_rule_set" "email_receipt_rule_set" {
  rule_set_name = "my_rule_set"
}

resource "aws_ses_receipt_rule" "email_receipt_rule" {
  rule_set_name = aws_ses_receipt_rule_set.email_receipt_rule_set.rule_set_name
  name = "my_email_rule"
  enabled = true
  recipients = ["rodrigogvianna@outlook.com"]

  s3_action {
    bucket_name = aws_s3_bucket.email_bucket.id
    object_key_prefix = "/consolidado_med.csv"
    position = 1
  }
}

resource "aws_s3_bucket" "email_bucket" {
  bucket = "email-amino"
}


resource "aws_s3_bucket_policy" "email_bucket_policy" {
  bucket = aws_s3_bucket.email_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEmailUploads",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.email_bucket.id}/*",
      "Condition": {
        "StringLike": {
          "aws:Referer": "${aws_ses_email_identity.from_address.email}"
        }
      }
    }
  ]
}
POLICY
}