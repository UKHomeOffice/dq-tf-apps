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
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}",
      "Condition":{"StringEquals":{"s3:prefix":[
        "",
        "s4/parsed/2018/",
        "s4/parsed/2018/06/",
        "s4/parsed/2018/06/16/",
        "s4/parsed/2018/06/17/",
        "s4/parsed/2018/06/18/",
        "s4/parsed/2018/06/19/",
        "s4/parsed/2018/06/20/",
        "s4/parsed/2018/06/21/",
        "s4/parsed/2018/06/22/",
        "s4/parsed/2018/06/23/",
        "s4/parsed/2018/06/24/",
        "s4/parsed/2018/06/25/",
        "s4/parsed/2018/06/26/",
        "s4/parsed/2018/06/27/",
        "s4/parsed/2018/06/28/",
        "s4/parsed/2018/06/29/",
        "s4/parsed/2018/06/30/"],
        "s3:delimiter":["/"]}}
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/16/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/17/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/18/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/19/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/20/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/21/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/22/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/23/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/24/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/25/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/26/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/27/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/28/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/29/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/06/30/*"
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
