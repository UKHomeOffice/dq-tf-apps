resource "aws_iam_user" "dq_mds_extractor_bucket" {
  name = "dq_mds_extractor_bucket_user"
}

resource "aws_iam_group" "dq_mds_extractor_bucket" {
  name = "dq_mds_extractor_bucket"
}

resource "aws_iam_policy" "dq_mds_extractor_bucket_policy" {
  name = "dq_mds_extractor_bucket_policy"

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
        "${aws_s3_bucket.mds_extract_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.mds_extract_bucket.arn}/*"
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
          "${aws_s3_bucket.mds_extract_bucket.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "dq_mds_extractor_bucket" {
  group      = aws_iam_group.dq_mds_extractor_bucket.name
  policy_arn = aws_iam_policy.dq_mds_extractor_bucket_policy.arn
}

resource "aws_iam_group_membership" "dq_mds_extractor_bucket" {
  name = "dq_mds_extractor_bucket"

  users = [aws_iam_user.dq_mds_extractor_bucket.name]

  group = aws_iam_group.dq_mds_extractor_bucket.name
}

