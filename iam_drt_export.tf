resource "aws_iam_group" "drt_export" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "iam-group-drt-export-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "drt_export" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "iam-group-membership-drt-export-${local.naming_suffix}"

  users = [
    aws_iam_user.drt_export[count.index].name,
  ]

  group = aws_iam_group.drt_export[count.index].name
}

resource "aws_iam_policy" "drt_export" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "iam-policy-drt-export-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.drt_export[count.index].arn}"
    },
    {
      "Sid": "PutS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.drt_export[count.index].arn}/*"
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

resource "aws_iam_group_policy_attachment" "drt_export" {
  count      = var.namespace == "notprod" ? 1 : 0
  group      = aws_iam_group.drt_export[count.index].id
  policy_arn = aws_iam_policy.drt_export[count.index].arn
}

resource "aws_iam_user" "drt_export" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "iam-user-drt-export-${local.naming_suffix}"
}

resource "aws_iam_access_key" "drt_export" {
  count = var.namespace == "notprod" ? 1 : 0
  user  = aws_iam_user.drt_export[count.index].name
}

resource "aws_ssm_parameter" "drt_export_id" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "DRT_AWS_ACCESS_KEY_ID"
  type  = "SecureString"
  value = aws_iam_access_key.drt_export[count.index].id
}

resource "aws_ssm_parameter" "drt_export_key" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "DRT_AWS_SECRET_ACCESS_KEY"
  type  = "SecureString"
  value = aws_iam_access_key.drt_export[count.index].secret
}
