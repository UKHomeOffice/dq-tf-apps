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
      "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "${aws_s3_bucket.athena_log_bucket.arn}",
        "${aws_s3_bucket.athena_log_bucket.arn}/${var.athena_keyprefix}/*"
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
    },
    {
      "Effect": "Allow"
      "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
          ],
      "Resource": [
        "${aws_cloudwatch_log_group.athena_cleanup.arn}",
        "${aws_cloudwatch_log_group.athena_cleanup.arn}/*"
      ]
    },
    {
      "Action": [
                "athena:StartQueryExecution",
                "athena:GetQueryExecution"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
                "glue:GetDatabase*",
                "glue:GetTable*",
                "glue:GetPartitions",
                "glue:DeleteTable"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "athena_cleanup" {
  name              = "/kubernetes/athena/${var.athena_keyprefix}"
  retention_in_days = 14

  tags = {
    Name = "kubernetes-log-group-athena-${var.athena_keyprefix}-${local.naming_suffix}"
  }
}

resource "aws_iam_user" "athena" {
  name = "iam-user-athena-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena" {
  user = "${aws_iam_user.athena.name}"
}

resource "aws_ssm_parameter" "athena_id" {
  name  = "kubernetes-athena-user-id-${var.athena_keyprefix}-${local.naming_suffix}"
  type  = "SecureString"
  value = "${aws_iam_access_key.athena.id}"
}

resource "aws_ssm_parameter" "athena_key" {
  name  = "kubernetes-athena-user-key-${var.athena_keyprefix}-${local.naming_suffix}"
  type  = "SecureString"
  value = "${aws_iam_access_key.athena.secret}"
}
