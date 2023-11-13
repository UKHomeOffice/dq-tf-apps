data "aws_caller_identity" "current" {
}

resource "aws_kms_key" "dq_s3_bucket_kms" {
  description             = "This key is used to encrypt daily tasks buckets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "dq-s3-kms-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "${data.aws_caller_identity.current.arn}",
                  "${data.aws_caller_identity.current.account_id}"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF

}
