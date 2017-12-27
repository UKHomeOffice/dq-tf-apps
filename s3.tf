resource "random_string" "bucket_string" {
  length  = 4
  upper   = false
  number  = false
  special = false
  lower   = true
}

resource "aws_kms_key" "log_archive_bucket_key" {
  description             = "This key is used to encrypt Archive Log bucket objects"
  deletion_window_in_days = 7

  tags = {
    Name             = "s3-${var.service}-log-archive-kms-key-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "log_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_log"]}-${random_string.bucket_string.result}"
  acl    = "${var.s3_bucket_acl["archive_log"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.log_archive_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name             = "s3-${var.service}-log-archive-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_iam_policy" "log_archive_bucket_policy" {
  name = "log_archive_bucket_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.log_archive_bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
        "s3:GetObject",
        "s3:ListObject"
      ],
      "Resource": ["${aws_s3_bucket.log_archive_bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_kms_key" "data_archive_bucket_key" {
  description             = "This key is used to encrypt Archive Log bucket objects"
  deletion_window_in_days = 7

  tags = {
    Name             = "s3-${var.service}-data-archive-kms-key-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "data_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_data"]}-${random_string.bucket_string.result}"
  acl    = "${var.s3_bucket_acl["archive_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.data_archive_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name             = "s3-${var.service}-data-archive-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_iam_policy" "data_archive_bucket_policy" {
  name = "data_archive_bucket_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.data_archive_bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
        "s3:GetObject",
        "s3:ListObject"
      ],
      "Resource": ["${aws_s3_bucket.data_archive_bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_kms_key" "data_working_bucket_key" {
  description             = "This key is used to encrypt Archive Log bucket objects"
  deletion_window_in_days = 7

  tags = {
    Name             = "s3-${var.service}-data-working-kms-key-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "data_working_bucket" {
  bucket = "${var.s3_bucket_name["working_data"]}-${random_string.bucket_string.result}"
  acl    = "${var.s3_bucket_acl["working_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.data_working_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name             = "s3-${var.service}-data-working-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_iam_policy" "data_working_bucket_policy" {
  name = "data_working_bucket_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.data_working_bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
        "s3:GetObject",
        "s3:ListObject"
      ],
      "Resource": ["${aws_s3_bucket.data_working_bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_kms_key" "data_landing_bucket_key" {
  description             = "This key is used to encrypt Archive Log bucket objects"
  deletion_window_in_days = 7

  tags = {
    Name             = "s3-${var.service}-data-landing-kms-key-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "data_landing_bucket" {
  bucket = "${var.s3_bucket_name["landing_data"]}-${random_string.bucket_string.result}"
  acl    = "${var.s3_bucket_acl["landing_data"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.data_landing_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name             = "s3-${var.service}-data-landing-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_iam_policy" "data_landing_bucket_policy" {
  name = "data_landing_bucket_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.data_landing_bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
        "s3:GetObject",
        "s3:ListObject"
      ],
      "Resource": ["${aws_s3_bucket.data_landing_bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_vpc_endpoint" "data_s3_endpoint" {
  vpc_id          = "${aws_vpc.appsvpc.id}"
  route_table_ids = ["${aws_route_table.apps_route_table.id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}

resource "aws_vpc_endpoint" "logs_s3_endpoint" {
  vpc_id          = "${aws_vpc.appsvpc.id}"
  route_table_ids = ["${aws_route_table.apps_route_table.id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}
