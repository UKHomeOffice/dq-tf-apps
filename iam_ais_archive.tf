resource "aws_iam_user" "dq_ais_archive_bucket" {
  name = "dq_ais_archive_bucket_user"
}

resource "aws_iam_group" "dq_ais_archive_bucket" {
  name = "dq_ais_archive_bucket"
}

resource "aws_iam_policy" "dq_ais_archive_bucket_policy" {
  name = "dq_ais_archive_bucket_policy"

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
        "${aws_s3_bucket.dq_ais_archive_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_ais_archive_bucket.arn}/*"
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
          "${aws_s3_bucket.dq_ais_archive_bucket.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "dq_ais_archive_bucket_policy" {
  group      = aws_iam_group.dq_ais_archive_bucket.id
  policy_arn = aws_iam_policy.dq_ais_archive_bucket_policy.arn
}

resource "aws_iam_group_membership" "dq_ais_archive_bucket" {
  name = "dq_ais_archive_bucket"

  users = [aws_iam_user.dq_ais_archive_bucket.name]

  group = aws_iam_group.dq_ais_archive_bucket.name
}

