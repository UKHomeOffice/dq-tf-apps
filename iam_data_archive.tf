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
  group = "cdp-s4-data"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
          "Action": ["s3:ListBucket", "s3:GetObject"]
          "Effect": "Allow",
          "Resource": "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018"
          "Condition":{"StringLike":{"s3:prefix":["09/07", "09/08", "09/09", "09/10", "09/11", "09/12", "09/13", "09/14", "09/16", "09/17", "09/18", "09/19", "09/20", "09/21", "09/22", "09/23", "09/24", "09/25", "09/26", "09/27", "09/28", "09/29", "09/30", "10/01", "10/02", "10/03", "10/04", "10/05", "10/06", "10/07", "10/08", "10/09", "10/10", "10/11", "10/12", "10/13", "10/14", "10/15", "10/16", "10/17", "10/18", "10/19"]}}
        },
  ]
}
EOF
}

resource "aws_iam_group_membership" "cdp-s4-data" {
  name = "cdp-s4-data"

  users = ["cdp-s4-data"]

  group = "cdp-s4-data"
}
