resource "aws_iam_user" "api_cdlz_msk_bucket" {
  name = "api_cdlz_msk_bucket_user"
}

resource "aws_iam_group" "api_cdlz_msk_bucket" {
  name = "api_cdlz_msk_bucket"
}

resource "aws_iam_policy" "api_cdlz_msk_bucket_policy" {
  name = "api_cdlz_msk_bucket_policy"

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
        "${aws_s3_bucket.api_cdlz_msk_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
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
          "${aws_s3_bucket.api_cdlz_msk_bucket.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "api_cdlz_msk_bucket" {
  group      = aws_iam_group.api_cdlz_msk_bucket.name
  policy_arn = aws_iam_policy.api_cdlz_msk_bucket_policy.arn
}

resource "aws_iam_group_membership" "api_cdlz_msk_bucket" {
  name = "api_cdlz_msk_bucket"

  users = [aws_iam_user.api_cdlz_msk_bucket.name]

  group = aws_iam_group.api_cdlz_msk_bucket.name
}
