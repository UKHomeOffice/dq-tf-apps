resource "aws_iam_user" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "notprod" ? 0 : 1
  name  = "dq_gait_landing_staging_bucket_user"
}


resource "aws_iam_access_key" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "notprod" ? 0 : 1
  user  = aws_iam_user.dq_gait_landing_staging_bucket[count.index].name
}

resource "aws_iam_group" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "notprod" ? 0 : 1
  name  = "dq_gait_landing_staging_bucket"
}

resource "aws_iam_policy" "dq_gait_landing_staging_bucket_policy" {
  count = var.namespace == "notprod" ? 0 : 1
  name  = "dq_gait_landing_staging_bucket_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_gait_landing_staging_bucket[0].arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_gait_landing_staging_bucket[0].arn}/*"
      ]
    },
    {
      "Action": [
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_gait_landing_staging_bucket[0].arn}/*"
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
        "Resource": [
          "${aws_s3_bucket.dq_gait_landing_staging_bucket[0].arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "api_archive_cdlz_bucket_policy" {
  group      = aws_iam_group.dq_gait_landing_staging_bucket[count.index].id
  policy_arn = aws_iam_policy.dq_gait_landing_staging_bucket_policy[count.index].arn
}

resource "aws_iam_group_membership" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "notprod" ? 0 : 1
  name  = "dq_gait_landing_staging_bucket"

  users = [aws_iam_user.dq_gait_landing_staging_bucket[count.index].name]

  group = aws_iam_group.dq_gait_landing_staging_bucket[count.index].name
}

resource "aws_ssm_parameter" "dq_gait_landing_staging_bucket_id" {
  count = var.namespace == "notprod" ? 0 : 1
  name  = "dq-gait-landing-staging-bucket-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_gait_landing_staging_bucket[count.index].id
}

resource "aws_ssm_parameter" "dq_gait_landing_staging_bucket_key" {
  count = var.namespace == "notprod" ? 0 : 1
  name  = "dq-gait-landing-staging-bucket-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_gait_landing_staging_bucket[count.index].secret
}
