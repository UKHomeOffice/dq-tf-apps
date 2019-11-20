resource "aws_iam_group" "cdlz" {
  name = "iam-group-cdlz-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "cdlz" {
  name = "iam-group-membership-cdlz-${local.naming_suffix}"

  users = [
    "${aws_iam_user.cdlz.name}"
  ]

  group = "${aws_iam_group.cdlz.name}"
}

resource "aws_iam_group_policy" "cdlz" {
  name  = "group-policy-cdlz-${local.naming_suffix}"
  group = "${aws_iam_group.cdlz.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.freight_archive_bucket.arn}"
    },
    {
      "Sid": "PutS3Bucket",
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.freight_archive_bucket.arn}/archive/*"
    },
    {
      "Sid": "UseKMSKey",
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

resource "aws_iam_user" "cdlz" {
  name = "iam-user-cdlz-${local.naming_suffix}"
}

resource "aws_iam_access_key" "cdlz" {
  user = "${aws_iam_user.cdlz.name}"
}
