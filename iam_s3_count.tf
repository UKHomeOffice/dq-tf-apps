resource "aws_iam_group" "s3count" {
  name = "iam-group-s3count-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "s3count" {
  name = "iam-group-membership-s3count-${local.naming_suffix}"

  users = [
    "${aws_iam_user.s3count.name}",
  ]

  group = "${aws_iam_group.s3count.name}"
}

resource "aws_iam_group_policy" "s3count" {
  name  = "iam-group-policy-s3count-${local.naming_suffix}"
  group = "${aws_iam_group.s3count.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": [
        "${aws_s3_bucket.data_archive_bucket.arn}",
        "${aws_s3_bucket.api_archive_bucket.arn}"
      ]
    },
    {
      "Sid": "GetS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.data_archive_bucket.arn}/*",
        "${aws_s3_bucket.api_archive_bucket.arn}/*"
      ]
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

resource "aws_iam_user" "s3count" {
  name = "iam-user-s3count-${local.naming_suffix}"
}

resource "aws_iam_access_key" "s3count" {
  user = "${aws_iam_user.s3count.name}"
}
