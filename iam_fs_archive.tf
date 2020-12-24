resource "aws_iam_user" "dq_fs_archive_bucket" {
  name = "dq_fs_archive_bucket_user"
}


resource "aws_iam_access_key" "dq_fs_archive_bucket" {
  user = aws_iam_user.dq_fs_archive_bucket.name
}

resource "aws_iam_group" "dq_fs_archive_bucket" {
  name = "dq_fs_archive_bucket"
}

resource "aws_iam_group_policy" "dq_fs_archive_bucket_policy" {
  name  = "dq_fs_archive_bucket_policy"
  group = aws_iam_group.dq_fs_archive_bucket.id

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
        "${aws_s3_bucket.dq_fs_archive.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_fs_archive.arn}/*"
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
          "${aws_s3_bucket.dq_fs_archive.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_group_membership" "dq_fs_archive_bucket" {
  name = "dq_fs_archive_bucket"

  users = [aws_iam_user.dq_fs_archive_bucket.name]

  group = aws_iam_group.dq_fs_archive_bucket.name
}

resource "aws_ssm_parameter" "dq_fs_archive_bucket_user" {
  name  = "FS_ARCHIVE_BUCKET_AWS_ACCESS_KEY_ID"
  type  = "SecureString"
  value = aws_iam_access_key.dq_fs_archive_bucket.id
}

resource "aws_ssm_parameter" "dq_fs_archive_bucket_secret" {
  name  = "FS_ARCHIVE_BUCKET_AWS_SECRET_ACCESS_KEY"
  type  = "SecureString"
  value = aws_iam_access_key.dq_fs_archive_bucket.secret
}
