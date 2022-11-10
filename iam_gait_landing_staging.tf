resource "aws_iam_user" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "prod" ? 1 : 0
  name  = "iam-user-gait-landing-staging-bucket-${local.naming_suffix}"
}


resource "aws_iam_group" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "prod" ? 1 : 0
  name  = "iam-group-gait-landing-staging-bucket-${local.naming_suffix}"
}

resource "aws_iam_policy" "dq_gait_landing_staging_bucket_policy" {
  count = var.namespace == "prod" ? 1 : 0
  name  = "iam-policy-gait-landing-staging-bucket-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_gait_landing_staging_bucket[0].arn}",
        "${aws_s3_bucket.dq_gait_landing_staging_bucket[0].arn}/*"
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

resource "aws_iam_group_policy_attachment" "dq_gait_landing_staging_bucket_policy" {
  count      = var.namespace == "prod" ? 1 : 0
  group      = aws_iam_group.dq_gait_landing_staging_bucket[0].id
  policy_arn = aws_iam_policy.dq_gait_landing_staging_bucket_policy[0].arn
}

resource "aws_iam_group_membership" "dq_gait_landing_staging_bucket" {
  count = var.namespace == "prod" ? 1 : 0
  name  = "iam-gait-landing-staging-bucket${local.naming_suffix}"

  users = [aws_iam_user.dq_gait_landing_staging_bucket[count.index].name]

  group = aws_iam_group.dq_gait_landing_staging_bucket[count.index].name
}
