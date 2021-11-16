resource "aws_iam_group" "rmr" {
  name = "iam-group-rmr-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "rmr" {
  name = "iam-group-membership-rmr-${local.naming_suffix}"

  users = [
    aws_iam_user.rmr.name,
  ]

  group = aws_iam_group.rmr.name
}

resource "aws_iam_policy" "rmr" {
  name = "rmr-policy-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": [
        "${aws_s3_bucket.data_archive_bucket.arn}",
        "${aws_s3_bucket.api_archive_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.data_archive_bucket.arn}/*",
        "${aws_s3_bucket.api_archive_bucket.arn}/*"
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

resource "aws_iam_group_policy_attachment" "rmr" {
  group      = aws_iam_group.rmr.name
  policy_arn = aws_iam_policy.rmr.arn
}

resource "aws_iam_user" "rmr" {
  name = "iam-user-rmr-${local.naming_suffix}"
}

# resource "aws_iam_access_key" "rmr_v2" {
#   user = aws_iam_user.rmr.name
# }
#
# resource "aws_ssm_parameter" "rmr_id" {
#   name  = "kubernetes-rmr-user-id-${local.naming_suffix}"
#   type  = "SecureString"
#   value = aws_iam_access_key.rmr_v2.id
# }
#
# resource "aws_ssm_parameter" "rmr_key" {
#   name  = "kubernetes-rmr-user-key-${local.naming_suffix}"
#   type  = "SecureString"
#   value = aws_iam_access_key.rmr_v2.secret
# }
