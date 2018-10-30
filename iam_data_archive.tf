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
      "Action": "s3:ListBucket",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}",
      "Condition":{"StringEquals":{"s3:prefix":[
        "",
        "s4/parsed/2018/",
        "s4/parsed/2018/09/",
        "s4/parsed/2018/09/07/",
        "s4/parsed/2018/09/08/",
        "s4/parsed/2018/09/09/",
        "s4/parsed/2018/09/10/",
        "s4/parsed/2018/09/11/",
        "s4/parsed/2018/09/12/",
        "s4/parsed/2018/09/13/",
        "s4/parsed/2018/09/14/",
        "s4/parsed/2018/09/15/",
        "s4/parsed/2018/09/16/",
        "s4/parsed/2018/09/17/",
        "s4/parsed/2018/09/18/",
        "s4/parsed/2018/09/19/",
        "s4/parsed/2018/09/20/",
        "s4/parsed/2018/09/21/",
        "s4/parsed/2018/09/22/",
        "s4/parsed/2018/09/23/",
        "s4/parsed/2018/09/24/",
        "s4/parsed/2018/09/25/",
        "s4/parsed/2018/09/26/",
        "s4/parsed/2018/09/27/",
        "s4/parsed/2018/09/28/",
        "s4/parsed/2018/09/29/",
        "s4/parsed/2018/09/30/",
        "s4/parsed/2018/10/",
        "s4/parsed/2018/10/01/",
        "s4/parsed/2018/10/02/",
        "s4/parsed/2018/10/03/",
        "s4/parsed/2018/10/04/",
        "s4/parsed/2018/10/05/",
        "s4/parsed/2018/10/06/",
        "s4/parsed/2018/10/07/",
        "s4/parsed/2018/10/08/",
        "s4/parsed/2018/10/09/",
        "s4/parsed/2018/10/10/",
        "s4/parsed/2018/10/11/",
        "s4/parsed/2018/10/12/",
        "s4/parsed/2018/10/13/",
        "s4/parsed/2018/10/14/",
        "s4/parsed/2018/10/15/",
        "s4/parsed/2018/10/16/",
        "s4/parsed/2018/10/17/",
        "s4/parsed/2018/10/18/",
        s4/parsed/2018/10/19/"],
        "s3:delimiter":["/"]}}
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/07/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/08/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/09/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/10/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/11/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/12/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/13/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/14/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/15/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/16/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/17/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/18/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/19/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/20/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/21/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/22/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/23/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/24/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/25/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/26/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/27/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/28/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/29/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/09/30/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/01/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/02/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/03/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/04/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/05/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/06/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/07/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/08/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/09/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/10/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/11/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/12/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/13/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/14/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/15/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/16/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/17/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/18/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/2018/10/19/*"
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
