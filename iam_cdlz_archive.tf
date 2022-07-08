resource "aws_iam_user" "api_archive_cdlz_bucket" {
  name = "api-archive-cdlz-user"
}

resource "aws_iam_group" "api_archive_cdlz_bucket" {
  name = "api-archive-cdlz-bucket"
}

resource "aws_iam_policy" "api_archive_cdlz_bucket_policy" {
  name = "api-archive-cdlz-bucket-policy"

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
        "${aws_s3_bucket.api_archive_bucket.arn}",
        "${aws_s3_bucket.data_archive_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.api_archive_bucket.arn}/*",
        "${aws_s3_bucket.data_archive_bucket.arn}/s4/parsed/*"
      ]
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::dsa-cdl-s3-deposit-s4-prod",
        "arn:aws:s3:::dsa-cdl-s3-deposit-s4-prod/*"
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
          "${aws_kms_key.bucket_key.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "api_archive_cdlz_bucket_policy" {
  group      = aws_iam_group.api_archive_cdlz_bucket.name
  policy_arn = aws_iam_policy.api_archive_cdlz_bucket_policy.arn
}

resource "aws_iam_group_membership" "api_archive_cdlz_bucket" {
  name = "api_archive_cdlz_bucket"

  users = [aws_iam_user.api_archive_cdlz_bucket.name]

  group = aws_iam_group.api_archive_cdlz_bucket.name
}
