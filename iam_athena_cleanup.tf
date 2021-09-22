resource "aws_iam_group" "athena" {
  name = "iam-group-athena-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "athena" {
  name = "iam-group-membership-athena-${local.naming_suffix}"

  users = [
    aws_iam_user.athena.name,
  ]

  group = aws_iam_group.athena.name
}

resource "aws_iam_policy" "athena" {
  name = "iam-policy-athena-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "${aws_s3_bucket.athena_log_bucket.arn}",
        "${aws_s3_bucket.athena_log_bucket.arn}/${var.athena_log_prefix}/*"
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
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.athena_log_bucket.arn}/${var.athena_log_prefix}/*"
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
    },
    {
      "Effect": "Allow",
      "Action": [
                "athena:StartQueryExecution",
                "athena:GetQueryExecution"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
                "glue:GetDatabase*",
                "glue:GetTable*",
                "glue:GetPartitions",
                "glue:DeleteTable",
                "glue:BatchDeletePartition"
      ],
      "Resource": [
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:catalog",
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/${var.athena_adhoc_maintenance_database}_${var.namespace}",
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/${var.athena_adhoc_maintenance_database}_${var.namespace}/${var.athena_adhoc_maintenance_table}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
                 "ssm:GetParameter"
      ],
      "Resource": [
      "arn:aws:ssm:eu-west-2:*:parameter/slack_notification_webhook"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "athena" {
  group      = aws_iam_group.athena.name
  policy_arn = aws_iam_policy.athena.arn
}

resource "aws_iam_user" "athena" {
  name = "iam-user-athena-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena" {
  user = aws_iam_user.athena.name
}

resource "aws_ssm_parameter" "athena_id" {
  name  = "kubernetes-athena-user-id-${var.athena_log_prefix}-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena.id
}

resource "aws_ssm_parameter" "athena_key" {
  name  = "kubernetes-athena-user-key-${var.athena_log_prefix}-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena.secret
}
