resource "aws_iam_group" "freight_external" {
  name = "iam-group-freight_external-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "freight_external" {
  name = "iam-group-membership-freight_external-${local.naming_suffix}"

  users = [
    "${aws_iam_user.freight_external.name}",
  ]

  group = "${aws_iam_group.freight_external.name}"
}

resource "aws_iam_group_policy" "freight_external" {
  name  = "group-policy-freight_external-${local.naming_suffix}"
  group = "${aws_iam_group.freight_external.id}"

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
      "Action": [
        "s3:PutObject"
      ],
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

resource "aws_iam_user" "freight_external" {
  name = "iam-user-freight_external-${local.naming_suffix}"
}

resource "aws_iam_access_key" "freight_external" {
  user = "${aws_iam_user.freight_external.name}"
}
