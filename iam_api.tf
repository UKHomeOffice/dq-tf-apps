resource "aws_iam_group" "api" {
  name = "iam-group-api-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "api" {
  name = "iam-group-membership-api-${local.naming_suffix}"

  users = [
    "${aws_iam_user.api.name}"
  ]

  group = "${aws_iam_group.api.name}"
}

resource "aws_iam_group_policy" "api" {
  name  = "iam-group-policy-api-${local.naming_suffix}"
  group = "${aws_iam_group.api.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.api_archive_bucket.arn}"
    },
    {
      "Sid": "PutS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.api_archive_bucket.arn}/*"
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

resource "aws_iam_user" "api" {
  name = "iam-user-api-${local.naming_suffix}"
}

resource "aws_iam_access_key" "api" {
  user = "${aws_iam_user.api.name}"
}
