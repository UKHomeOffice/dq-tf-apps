resource "aws_kms_key" "test_kms_key" {
  description             = "Test key for KMS S3 encryption"
  deletion_window_in_days = 7

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${data.aws_caller_identity.current.arn}"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow services use of the key",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "kms_test_bucket" {
  bucket = "s3-kms-test-bucket-${local.naming_suffix}"
  acl    = "private"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.test_kms_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-kms-test-bucket-${local.naming_suffix}"
  }
}
