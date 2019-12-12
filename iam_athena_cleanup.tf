resource "aws_iam_group" "athena" {
  name = "iam-group-athena-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "athena" {
  name = "iam-group-membership-athena-${local.naming_suffix}"

  users = [
    "${aws_iam_user.athena.name}",
  ]

  group = "${aws_iam_group.athena.name}"
}

resource "aws_iam_group_policy" "athena" {
  name  = "iam-group-policy-athena-${local.naming_suffix}"
  group = "${aws_iam_group.athena.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": [
        "${aws_s3_bucket.athena_log_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.athena_log_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.athena_log_bucket.arn}/${var.athena_keyprefix}/*"
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

resource "aws_iam_user" "athena" {
  name = "iam-user-athena-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena" {
  user = "${aws_iam_user.athena.name}"
}
