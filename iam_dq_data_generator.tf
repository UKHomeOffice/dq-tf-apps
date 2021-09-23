resource "aws_iam_policy" "dq_data_generator_bucket_policy" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "dq_data_generator_bucket_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_data_generator_bucket[0].arn}",
        "${aws_s3_bucket.dq_data_generator_bucket[0].arn}/*",
        "${aws_s3_bucket.api_cdlz_msk_bucket.arn}",
        "${aws_s3_bucket.api_cdlz_msk_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_data_generator_bucket[0].arn}/*",
        "${aws_s3_bucket.api_cdlz_msk_bucket.arn}/*"
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
          "${aws_s3_bucket.dq_data_generator_bucket[0].arn}",
          "${aws_s3_bucket.api_cdlz_msk_bucket.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "dq_data_generator_bucket" {
  count      = var.namespace == "notprod" ? 1 : 0
  group      = aws_iam_group.dq_data_generator_bucket[count.index].id
  policy_arn = aws_iam_policy.dq_data_generator_bucket_policy[count.index].arn
}

resource "aws_iam_user" "dq_data_generator_bucket" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "dq_data_generator_bucket_user"
}


resource "aws_iam_access_key" "dq_data_generator_bucket" {
  count = var.namespace == "notprod" ? 1 : 0
  user  = aws_iam_user.dq_data_generator_bucket[count.index].name
}

resource "aws_iam_group" "dq_data_generator_bucket" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "dq_data_generator_bucket"
}

resource "aws_iam_group_membership" "dq_data_generator_bucket" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "dq_data_generator_bucket"

  users = [aws_iam_user.dq_data_generator_bucket[count.index].name]

  group = aws_iam_group.dq_data_generator_bucket[count.index].name
}

resource "aws_ssm_parameter" "dq_data_generator_bucket_id" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "dq-data-generator-bucket-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_data_generator_bucket[count.index].id
}

resource "aws_ssm_parameter" "dq_data_generator_bucket_key" {
  count = var.namespace == "notprod" ? 1 : 0
  name  = "dq-data-generator-bucket-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_data_generator_bucket[count.index].secret
}
