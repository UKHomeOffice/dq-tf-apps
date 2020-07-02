resource "aws_iam_user" "api_cdlz_msk_bucket" {
  name = "api_cdlz_msk_bucket_user"
}


resource "aws_iam_access_key" "api_cdlz_msk_bucket" {
  user = aws_iam_user.api_cdlz_msk_bucket.name
}

resource "aws_iam_group" "api_cdlz_msk_bucket" {
  name = "api_cdlz_msk_bucket"
}

resource "aws_iam_group_policy" "api_cdlz_msk_bucket_policy" {
  name  = "api_cdlz_msk_bucket_policy"
  group = "${aws_iam_group.api_cdlz_msk_bucket.id}"

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

resource "aws_iam_group_membership" "api_cdlz_msk_bucket" {
  name = "api_cdlz_msk_bucket"

  users = [aws_iam_user.api_cdlz_msk_bucket.name]

  group = aws_iam_group.api_cdlz_msk_bucket.name
}
