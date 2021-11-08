resource "aws_iam_user" "dq_gait_landing_staging_bucket" {
  name = "dq_gait_landing_staging_bucket_user"
}


resource "aws_iam_access_key" "dq_gait_landing_staging_bucket" {
  user = aws_iam_user.dq_gait_landing_staging_bucket.name
}

resource "aws_iam_group" "dq_gait_landing_staging_bucket" {
  name = "dq_gait_landing_staging_bucket"
}

resource "aws_iam_group_policy" "dq_gait_landing_staging_bucket_policy" {
  name  = "dq_gait_landing_staging_bucket_policy"
  group = aws_iam_group.dq_gait_landing_staging_bucket.id

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
        "${aws_s3_bucket.dq_gait_landing_staging_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_gait_landing_staging_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_gait_landing_staging_bucket.arn}/*"
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
          "${aws_s3_bucket.dq_gait_landing_staging_bucket.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_membership" "dq_gait_landing_staging_bucket" {
  name = "dq_gait_landing_staging_bucket"

  users = [aws_iam_user.dq_gait_landing_staging_bucket.name]

  group = aws_iam_group.dq_gait_landing_staging_bucket.name
}

resource "aws_ssm_parameter" "dq_gait_landing_staging_bucket_id" {
  name  = "dq-gait-landing-staging-bucket-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_gait_landing_staging_bucket.id
}

resource "aws_ssm_parameter" "dq_gait_landing_staging_bucket_key" {
  name  = "dq-gait-landing-staging-bucket-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_gait_landing_staging_bucket.secret
}
