resource "aws_iam_user" "dq_ais_archive_bucket" {
  name = "dq_ais_archive_bucket_user"
}


resource "aws_iam_access_key" "dq_ais_archive_bucket" {
  user = aws_iam_user.dq_ais_archive_bucket.name
}

resource "aws_iam_group" "dq_ais_archive_bucket" {
  name = "dq_ais_archive_bucket"
}

resource "aws_iam_group_policy" "dq_ais_archive_bucket_policy" {
  name  = "dq_ais_archive_bucket_policy"
  group = aws_iam_group.dq_ais_archive_bucket.id

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
        "s3:PutObject"
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

resource "aws_iam_group_membership" "dq_ais_archive_bucket" {
  name = "dq_ais_archive_bucket"

  users = [aws_iam_user.dq_ais_archive_bucket.name]

  group = aws_iam_group.dq_ais_archive_bucket.name
}

resource "aws_ssm_parameter" "dq_ais_archive_bucket_id" {
  name  = "dq-ais-archive-bucket-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_ais_archive_bucket.id
}

resource "aws_ssm_parameter" "dq_ais_archive_bucket_key" {
  name  = "dq-ais-archive-bucket-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_ais_archive_bucket.secret
}
