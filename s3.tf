resource "aws_kms_key" "bucket_key" {
  description             = "This key is used to encrypt APPS buckets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

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
  bucket = var.s3_bucket_name["archive_log"]
  acl    = var.s3_bucket_acl["archive_log"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-log-archive-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_metric" "log_archive_bucket_logging" {
  bucket = var.s3_bucket_name["archive_log"]
  name   = "log_archive_bucket_metric"
}

resource "aws_s3_bucket_policy" "archive_log_policy" {
  bucket = var.s3_bucket_name["archive_log"]

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
  bucket = var.s3_bucket_name["archive_data"]
  acl    = var.s3_bucket_acl["archive_data"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "data_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "internal_tableau_green"
    enabled = true

    prefix = "tableau-int/green/"

    expiration {
      days = 15
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  lifecycle_rule {
    id      = "internal_tableau_blue"
    enabled = true

    prefix = "tableau-int/blue/"

    expiration {
      days = 15
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  lifecycle_rule {
    id      = "external_tableau_green"
    enabled = true

    prefix = "tableau-ext/green/"

    expiration {
      days = 15
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  lifecycle_rule {
    id      = "external_tableau_blue"
    enabled = true

    prefix = "tableau-ext/blue/"

    expiration {
      days = 15
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  tags = {
    Name = "s3-data-archive-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_metric" "data_archive_bucket_logging" {
  bucket = var.s3_bucket_name["archive_data"]
  name   = "data_archive_bucket_metric"
}

resource "aws_s3_bucket_policy" "data_archive_bucket" {
  bucket = var.s3_bucket_name["archive_data"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["archive_data"]}/*",
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

resource "aws_s3_bucket" "data_working_bucket" {
  bucket = var.s3_bucket_name["working_data"]
  acl    = var.s3_bucket_acl["working_data"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "data_working_bucket/"
  }

  tags = {
    Name = "s3-data-working-bucket-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_metric" "data_working_bucket_logging" {
  bucket = var.s3_bucket_name["working_data"]
  name   = "data_working_bucket_metric"
}

resource "aws_s3_bucket_policy" "data_working_bucket" {
  bucket = var.s3_bucket_name["working_data"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["working_data"]}/*",
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

resource "aws_s3_bucket" "airports_archive_bucket" {
  bucket = var.s3_bucket_name["airports_archive"]
  acl    = var.s3_bucket_acl["airports_archive"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "airports_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-dq-airports-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "airports_archive_policy" {
  bucket = var.s3_bucket_name["airports_archive"]

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
  bucket = var.s3_bucket_name["airports_internal"]
  acl    = var.s3_bucket_acl["airports_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "airports_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-airports-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "airports_internal_policy" {
  bucket = var.s3_bucket_name["airports_internal"]

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
  bucket = var.s3_bucket_name["airports_working"]
  acl    = var.s3_bucket_acl["airports_working"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "airports_working_bucket/"
  }

  tags = {
    Name = "s3-dq-airports-working-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "airports_working_policy" {
  bucket = var.s3_bucket_name["airports_working"]

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
  bucket = var.s3_bucket_name["oag_archive"]
  acl    = var.s3_bucket_acl["oag_archive"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "oag_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-dq-oag-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "oag_archive_policy" {
  bucket = var.s3_bucket_name["oag_archive"]

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
  bucket = var.s3_bucket_name["oag_internal"]
  acl    = var.s3_bucket_acl["oag_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "oag_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-oag-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "oag_internal_policy" {
  bucket = var.s3_bucket_name["oag_internal"]

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
  bucket = var.s3_bucket_name["oag_transform"]
  acl    = var.s3_bucket_acl["oag_transform"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "oag_transform_bucket/"
  }

  tags = {
    Name = "s3-dq-oag-transform-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "oag_transform_policy" {
  bucket = var.s3_bucket_name["oag_transform"]

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

resource "aws_s3_bucket_metric" "oag_transform_bucket_logging" {
  bucket = var.s3_bucket_name["oag_transform"]
  name   = "oag_transform_bucket_metric"
}

resource "aws_s3_bucket" "acl_archive_bucket" {
  bucket = var.s3_bucket_name["acl_archive"]
  acl    = var.s3_bucket_acl["acl_archive"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "acl_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-dq-acl-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "acl_archive_policy" {
  bucket = var.s3_bucket_name["acl_archive"]

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
  bucket = var.s3_bucket_name["acl_internal"]
  acl    = var.s3_bucket_acl["acl_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "acl_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-acl-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "acl_internal_policy" {
  bucket = var.s3_bucket_name["acl_internal"]

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
  bucket = var.s3_bucket_name["reference_data_archive"]
  acl    = var.s3_bucket_acl["reference_data_archive"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "reference_data_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-dq-reference-data-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "reference_data_archive_policy" {
  bucket = var.s3_bucket_name["reference_data_archive"]

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
  bucket = var.s3_bucket_name["reference_data_internal"]
  acl    = var.s3_bucket_acl["reference_data_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "reference_data_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-reference-data-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "reference_data_internal_policy" {
  bucket = var.s3_bucket_name["reference_data_internal"]

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
  bucket = var.s3_bucket_name["consolidated_schedule"]
  acl    = var.s3_bucket_acl["consolidated_schedule"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "consolidated_schedule_bucket/"
  }

  tags = {
    Name = "s3-dq-consolidated-schedule-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "consolidated_schedule_policy" {
  bucket = var.s3_bucket_name["consolidated_schedule"]

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

resource "aws_s3_bucket_metric" "consolidated_schedule_bucket_logging" {
  bucket = var.s3_bucket_name["consolidated_schedule"]
  name   = "consolidated_schedule_bucket_metric"
}

resource "aws_s3_bucket" "api_archive_bucket" {
  bucket = var.s3_bucket_name["api_archive"]
  acl    = var.s3_bucket_acl["api_archive"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "api_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-dq-api-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "api_archive_policy" {
  bucket = var.s3_bucket_name["api_archive"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["api_archive"]}/*",
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

resource "aws_s3_bucket_metric" "api_archive_bucket_logging" {
  bucket = var.s3_bucket_name["api_archive"]
  name   = "api_archive_bucket_metric"
}

resource "aws_s3_bucket" "api_internal_bucket" {
  bucket = var.s3_bucket_name["api_internal"]
  acl    = var.s3_bucket_acl["api_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "api_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-api-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "api_internal_policy" {
  bucket = var.s3_bucket_name["api_internal"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["api_internal"]}/*",
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

resource "aws_s3_bucket_metric" "api_internal_bucket_logging" {
  bucket = var.s3_bucket_name["api_internal"]
  name   = "api_internal_bucket_metric"
}

resource "aws_s3_bucket" "api_record_level_scoring_bucket" {
  bucket = var.s3_bucket_name["api_record_level_scoring"]
  acl    = var.s3_bucket_acl["api_record_level_scoring"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "api_record_level_scoring_bucket/"
  }

  tags = {
    Name = "s3-dq-api-record-level-scoring-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "api_record_level_scoring_policy" {
  bucket = var.s3_bucket_name["api_record_level_scoring"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["api_record_level_scoring"]}/*",
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

resource "aws_s3_bucket_metric" "api_record_level_scoring_logging" {
  bucket = var.s3_bucket_name["api_record_level_scoring"]
  name   = "api_record_level_scoring_bucket_metric"
}

resource "aws_s3_bucket" "cross_record_scored_bucket" {
  bucket = var.s3_bucket_name["cross_record_scored"]
  acl    = var.s3_bucket_acl["cross_record_scored"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "cross_record_scored_bucket/"
  }

  tags = {
    Name = "s3-dq-cross-record-scored-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "cross_record_scored_policy" {
  bucket = var.s3_bucket_name["cross_record_scored"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["cross_record_scored"]}/*",
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

resource "aws_s3_bucket_metric" "cross_record_scored_logging" {
  bucket = var.s3_bucket_name["cross_record_scored"]
  name   = "api_cross_record_scored_bucket_metric"
}

resource "aws_s3_bucket" "gait_internal_bucket" {
  bucket = var.s3_bucket_name["gait_internal"]
  acl    = var.s3_bucket_acl["gait_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "gait_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-gait-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "gait_internal_policy" {
  bucket = var.s3_bucket_name["gait_internal"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["gait_internal"]}/*",
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

resource "aws_s3_bucket" "reporting_internal_working_bucket" {
  bucket = var.s3_bucket_name["reporting_internal_working"]
  acl    = var.s3_bucket_acl["reporting_internal_working"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "reporting_internal_working_bucket/"
  }

  tags = {
    Name = "s3-dq-reporting-internal-working-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "reporting_internal_working_policy" {
  bucket = var.s3_bucket_name["reporting_internal_working"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["reporting_internal_working"]}/*",
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

resource "aws_s3_bucket_metric" "reporting_internal_working_logging" {
  bucket = var.s3_bucket_name["reporting_internal_working"]
  name   = "reporting_internal_working_bucket_metric"
}

resource "aws_s3_bucket" "carrier_portal_working_bucket" {
  bucket = var.s3_bucket_name["carrier_portal_working"]
  acl    = var.s3_bucket_acl["carrier_portal_working"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "carrier_portal_working_bucket/"
  }

  tags = {
    Name = "s3-dq-carrier-portal-working-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "carrier_portal_working_policy" {
  bucket = var.s3_bucket_name["carrier_portal_working"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["carrier_portal_working"]}/*",
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

resource "aws_s3_bucket_metric" "carrier_portal_working_logging" {
  bucket = var.s3_bucket_name["carrier_portal_working"]
  name   = "carrier_portal_working_bucket_metric"
}

resource "aws_s3_bucket" "athena_log_bucket" {
  bucket = var.s3_bucket_name["athena_log"]
  acl    = var.s3_bucket_acl["athena_log"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "athena_log_bucket/"
  }

  tags = {
    Name = "s3-dq-athena-log-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "athena_log_policy" {
  bucket = var.s3_bucket_name["athena_log"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["athena_log"]}/*",
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

resource "aws_s3_bucket" "mds_extract_bucket" {
  bucket = var.s3_bucket_name["mds_extract"]
  acl    = var.s3_bucket_acl["mds_extract"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "mds_extract_bucket/"
  }

  tags = {
    Name = "s3-dq-mds-extract-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "mds_extract_policy" {
  bucket = var.s3_bucket_name["mds_extract"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["mds_extract"]}/*",
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

resource "aws_s3_bucket" "raw_file_index_internal_bucket" {
  bucket = var.s3_bucket_name["raw_file_index_internal"]
  acl    = var.s3_bucket_acl["raw_file_index_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "raw_file_index_internal_bucket/"
  }

  tags = {
    Name = "s3-dq-raw-file-retrieval-index-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "raw_file_index_internal_policy" {
  bucket = var.s3_bucket_name["raw_file_index_internal"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["raw_file_index_internal"]}/*",
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

resource "aws_s3_bucket" "fms_working_bucket" {
  bucket = var.s3_bucket_name["fms_working"]
  acl    = var.s3_bucket_acl["fms_working"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "fms_working_bucket/"
  }

  tags = {
    Name = "s3-dq-fms-working-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "fms_working_policy" {
  bucket = var.s3_bucket_name["fms_working"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["fms_working"]}/*",
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

resource "aws_s3_bucket" "drt_working_bucket" {
  bucket = var.s3_bucket_name["drt_working"]
  acl    = var.s3_bucket_acl["drt_working"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "drt_working_bucket/"
  }

  tags = {
    Name = "s3-dq-drt-working-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "drt_working_policy" {
  bucket = var.s3_bucket_name["drt_working"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["drt_working"]}/*",
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

resource "aws_s3_bucket" "nats_archive_bucket" {
  bucket = var.s3_bucket_name["nats_archive"]
  acl    = var.s3_bucket_acl["nats_archive"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "nats_archive_bucket/"
  }

  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "s3-dq-nats-archive-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "nats_archive_policy" {
  bucket = var.s3_bucket_name["nats_archive"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["nats_archive"]}/*",
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

resource "aws_s3_bucket" "nats_internal_bucket" {
  bucket = var.s3_bucket_name["nats_internal"]
  acl    = var.s3_bucket_acl["nats_internal"]
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "nats_internal/"
  }

  tags = {
    Name = "nats-internal-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "nats_internal_policy" {
  bucket = var.s3_bucket_name["nats_internal"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["nats_internal"]}/*",
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

resource "aws_s3_bucket_metric" "drt_working_logging" {
  bucket = var.s3_bucket_name["drt_working"]
  name   = "drt_working_bucket_metric"
}

resource "aws_s3_bucket" "cdlz_bitd_input" {
  bucket = var.s3_bucket_name["cdlz_bitd_input"]
  acl    = var.s3_bucket_acl["cdlz_bitd_input"]

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "cdlz_bitd_input/"
  }

  tags = {
    Name = "s3-dq-cdlz-bitd-input-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "cdlz_bitd_input_policy" {
  bucket = var.s3_bucket_name["cdlz_bitd_input"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["cdlz_bitd_input"]}/*",
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

resource "aws_s3_bucket_metric" "cdlz_bitd_input_logging" {
  bucket = var.s3_bucket_name["cdlz_bitd_input"]
  name   = "cdlz_bitd_input_bucket_metric"
}

resource "aws_s3_bucket" "api_arrivals_bucket" {
  bucket = var.s3_bucket_name["api_arrivals"]
  acl    = var.s3_bucket_acl["api_arrivals"]

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "api_arrivals/"
  }

  tags = {
    Name = "s3-dq-api-arrivals-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_object" "s3-dq-api-arrivals-test" {
  bucket = var.s3_bucket_name["api_arrivals"]
  key    = "reference/"
}

resource "aws_s3_bucket_policy" "api_arrivals_policy" {
  bucket = var.s3_bucket_name["api_arrivals"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["api_arrivals"]}/*",
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

resource "aws_s3_bucket_metric" "api_arrivals_logging" {
  bucket = var.s3_bucket_name["api_arrivals"]
  name   = "api_arrivals_bucket_metric"
}

resource "aws_s3_bucket" "accuracy_score_bucket" {
  bucket = var.s3_bucket_name["accuracy_score"]
  acl    = var.s3_bucket_acl["accuracy_score"]

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_archive_bucket.id
    target_prefix = "accuracy_score/"
  }

  tags = {
    Name = "s3-dq-accuracy-score-${local.naming_suffix}"
  }
}

resource "aws_s3_bucket_policy" "accuracy_score_policy" {
  bucket = var.s3_bucket_name["accuracy_score"]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name["accuracy_score"]}/*",
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

resource "aws_s3_bucket_metric" "accuracy_score_logging" {
  bucket = var.s3_bucket_name["accuracy_score"]
  name   = "accuracy_score_bucket_metric"
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id          = aws_vpc.appsvpc.id
  route_table_ids = [aws_route_table.apps_route_table.id]
  service_name    = "com.amazonaws.eu-west-2.s3"
}

