resource "aws_kms_key" "bucket_key" {
  description             = "This key is used to encrypt APPS buckets"
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

resource "aws_s3_bucket" "log_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_log"]}"
  acl    = "${var.s3_bucket_acl["archive_log"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-log-archive-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_metric" "log_archive_bucket_logging" {
  bucket = "${var.s3_bucket_name["archive_log"]}"
  name   = "log_archive_bucket_metric"
}

resource "aws_s3_bucket" "data_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_data"]}"
  acl    = "${var.s3_bucket_acl["archive_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.log_archive_bucket.id}"
    target_prefix = "data_archive_bucket/"
  }

  tags = {
    Name = "s3-data-archive-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_metric" "data_archive_bucket_logging" {
  bucket = "${var.s3_bucket_name["archive_data"]}"
  name   = "data_archive_bucket_metric"
}

resource "aws_s3_bucket" "data_working_bucket" {
  bucket = "${var.s3_bucket_name["working_data"]}"
  acl    = "${var.s3_bucket_acl["working_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.log_archive_bucket.id}"
    target_prefix = "data_working_bucket/"
  }

  tags = {
    Name = "s3-data-working-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_metric" "data_working_bucket_logging" {
  bucket = "${var.s3_bucket_name["working_data"]}"
  name   = "data_working_bucket_metric"
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id          = "${aws_vpc.appsvpc.id}"
  route_table_ids = ["${aws_route_table.apps_route_table.id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}
