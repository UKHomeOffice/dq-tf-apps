resource "aws_iam_group" "crt" {
  name = "iam-group-crt-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "crt" {
  name = "iam-group-membership-crt-${local.naming_suffix}"

  users = [
    aws_iam_user.crt.name,
  ]

  group = aws_iam_group.crt.name
}

resource "aws_iam_policy" "crt" {
  name = "iam-policy-crt-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}"
    },
    {
      "Sid": "GetS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}/crt-backup/*"
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

resource "aws_iam_group_policy_attachment" "crt" {
  group      = aws_iam_group.crt.name
  policy_arn = aws_iam_policy.crt.arn
}

resource "aws_iam_user" "crt" {
  name = "iam-user-crt-${local.naming_suffix}"
}

resource "aws_iam_access_key" "crt_v2" {
  user = aws_iam_user.crt.name
}

resource "aws_ssm_parameter" "crt_id" {
  name  = "kubernetes-crt-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.crt_v2.id
}

resource "aws_ssm_parameter" "crt_key" {
  name  = "kubernetes-crt-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.crt_v2.secret
}

resource "aws_ssm_parameter" "dimension_data_user" {
  name  = "Dimension_data_user-crt-${local.naming_suffix}"
  type  = "String"
  value = random_string.dimension_data_user_random.result
}

resource "random_string" "dimension_data_user_random" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "aws_ssm_parameter" "dimension_data_password_random" {
  name  = "Dimension_data_password-crt-${local.naming_suffix}"
  value = random_string.dimension_data_password_random.result
  type  = "SecureString"
}

resource "random_string" "dimension_data_password_random" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}
