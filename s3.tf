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
                "AWS": [
                  "${data.aws_caller_identity.current.arn}",
                  "${data.aws_caller_identity.current.account_id}"
                ]
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

resource "aws_s3_bucket_policy" "archive_log_policy" {
  bucket = "${var.s3_bucket_name["archive_log"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["archive_log"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
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

resource "aws_s3_bucket" "airports_archive_bucket" {
  bucket = "${var.s3_bucket_name["airports_archive"]}"
  acl    = "${var.s3_bucket_acl["airports_archive"]}"
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
    target_prefix = "airports_archive_bucket/"
  }

  tags = {
    Name = "s3-dq-airports-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "airports_archive_policy" {
  bucket = "${var.s3_bucket_name["airports_archive"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["airports_archive"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "airports_internal_bucket" {
  bucket = "${var.s3_bucket_name["airports_internal"]}"
  acl    = "${var.s3_bucket_acl["airports_internal"]}"
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
    target_prefix = "airports_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-airports-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "airports_internal_policy" {
  bucket = "${var.s3_bucket_name["airports_internal"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["airports_internal"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "airports_working_bucket" {
  bucket = "${var.s3_bucket_name["airports_working"]}"
  acl    = "${var.s3_bucket_acl["airports_working"]}"
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
    target_prefix = "airports_working_bucket/"
  }

  tags = {
    Name = "s3-dq-airports-working-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "airports_working_policy" {
  bucket = "${var.s3_bucket_name["airports_working"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["airports_working"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "oag_archive_bucket" {
  bucket = "${var.s3_bucket_name["oag_archive"]}"
  acl    = "${var.s3_bucket_acl["oag_archive"]}"
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
    target_prefix = "oag_archive_bucket/"
  }

  tags = {
    Name = "s3-dq-oag-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "oag_archive_policy" {
  bucket = "${var.s3_bucket_name["oag_archive"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["oag_archive"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "oag_internal_bucket" {
  bucket = "${var.s3_bucket_name["oag_internal"]}"
  acl    = "${var.s3_bucket_acl["oag_internal"]}"
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
    target_prefix = "oag_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-oag-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "oag_internal_policy" {
  bucket = "${var.s3_bucket_name["oag_internal"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["oag_internal"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "oag_transform_bucket" {
  bucket = "${var.s3_bucket_name["oag_transform"]}"
  acl    = "${var.s3_bucket_acl["oag_transform"]}"
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
    target_prefix = "oag_transform_bucket/"
  }

  tags = {
    Name = "s3-dq-oag-transform-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "oag_transform_policy" {
  bucket = "${var.s3_bucket_name["oag_transform"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["oag_transform"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "acl_archive_bucket" {
  bucket = "${var.s3_bucket_name["acl_archive"]}"
  acl    = "${var.s3_bucket_acl["acl_archive"]}"
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
    target_prefix = "acl_archive_bucket/"
  }

  tags = {
    Name = "s3-dq-acl-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "acl_archive_policy" {
  bucket = "${var.s3_bucket_name["acl_archive"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["acl_archive"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "acl_internal_bucket" {
  bucket = "${var.s3_bucket_name["acl_internal"]}"
  acl    = "${var.s3_bucket_acl["acl_internal"]}"
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
    target_prefix = "acl_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-acl-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "acl_internal_policy" {
  bucket = "${var.s3_bucket_name["acl_internal"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["acl_internal"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "reference_data_archive_bucket" {
  bucket = "${var.s3_bucket_name["reference_data_archive"]}"
  acl    = "${var.s3_bucket_acl["reference_data_archive"]}"
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
    target_prefix = "reference_data_archive_bucket/"
  }

  tags = {
    Name = "s3-dq-reference-data-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "reference_data_archive_policy" {
  bucket = "${var.s3_bucket_name["reference_data_archive"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["reference_data_archive"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "reference_data_internal_bucket" {
  bucket = "${var.s3_bucket_name["reference_data_internal"]}"
  acl    = "${var.s3_bucket_acl["reference_data_internal"]}"
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
    target_prefix = "reference_data_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-reference-data-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "reference_data_internal_policy" {
  bucket = "${var.s3_bucket_name["reference_data_internal"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["reference_data_internal"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "consolidated_schedule_bucket" {
  bucket = "${var.s3_bucket_name["consolidated_schedule"]}"
  acl    = "${var.s3_bucket_acl["consolidated_schedule"]}"
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
    target_prefix = "consolidated_schedule_bucket/"
  }

  tags = {
    Name = "s3-dq-consolidated-schedule-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "consolidated_schedule_policy" {
  bucket = "${var.s3_bucket_name["consolidated_schedule"]}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["consolidated_schedule"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id          = "${aws_vpc.appsvpc.id}"
  route_table_ids = ["${aws_route_table.apps_route_table.id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}


