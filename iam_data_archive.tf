resource "aws_iam_user" "data_archive_bucket" {
  name = "data_archive_bucket_user"
}

resource "aws_iam_access_key" "data_archive_bucket" {
  user = "${aws_iam_user.data_archive_bucket.name}"
}

resource "aws_iam_group" "data_archive_bucket" {
  name = "data_archive_bucket"
}

resource "aws_iam_group_policy" "data_archive_bucket" {
  group = "${aws_iam_group.data_archive_bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:ListBucket",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}"
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
        ],
        "Resource": "${aws_kms_key.bucket_key.arn}"
      }
  ]
}
EOF
}

resource "aws_iam_group_membership" "data_archive_bucket" {
  name = "data_archive_bucket"

  users = ["${aws_iam_user.data_archive_bucket.name}"]

  group = "${aws_iam_group.data_archive_bucket.name}"
}

resource "aws_iam_user" "cdp-s4-data" {
  name = "cdp-s4-data"
}

resource "aws_iam_access_key" "cdp-s4-data" {
  user = "cdp-s4-data"
}

resource "aws_iam_group" "cdp-s4-data" {
  name = "cdp-s4-data"
}

resource "aws_iam_group_policy" "cdp-s4-data" {
  name  = "cdp-s4-data"
  group = "cdp-s4-data"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:ListObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.api_archive_bucket.arn}",
      "Condition":{"StringLike":{"s3:prefix":[
        "",
        "parsed/2019-06-08/*",
        "parsed/2019-06-09/*",
        "parsed/2019-06-10/*",
        "parsed/2019-06-11/*",
        "parsed/2019-06-12/*",
        "parsed/2019-06-13/*",
        "parsed/2019-06-14/*"],
        "s3:delimiter":["/"]}}
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.api_archive_bucket.arn}/s4/parsed/2018/06/16/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-08/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-09/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-10/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-11/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-12/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-13/*",
        "${aws_s3_bucket.api_archive_bucket.arn}parsed/2019-06-14/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
        ],
        "Resource": "${aws_kms_key.bucket_key.arn}"
      }
  ]
}
EOF
}

resource "aws_iam_group_membership" "cdp-s4-data" {
  name = "cdp-s4-data"

  users = ["cdp-s4-data"]

  group = "cdp-s4-data"
}
