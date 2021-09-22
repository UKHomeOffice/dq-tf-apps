resource "aws_iam_user" "data_archive_bucket" {
  name = "data_archive_bucket_user"
}

resource "aws_iam_access_key" "data_archive_bucket_v2" {
  user = aws_iam_user.data_archive_bucket.name
}

resource "aws_iam_group" "data_archive_bucket" {
  name = "data_archive_bucket"
}

resource "aws_iam_policy" "data_archive_bucket" {
  name = "iam-policy-data-archive-bucket-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:ListBucket",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}"
    },
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}/*"
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
        "Resource": "${aws_kms_key.bucket_key.arn}"
      }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "data_archive_bucket" {
  group      = aws_iam_group.data_archive_bucket.name
  policy_arn = aws_iam_policy.data_archive_bucket.arn
}

resource "aws_iam_group_membership" "data_archive_bucket" {
  name = "data_archive_bucket"

  users = [aws_iam_user.data_archive_bucket.name]

  group = aws_iam_group.data_archive_bucket.name
}

resource "aws_ssm_parameter" "jira_id" {
  name  = "kubernetes-jira-backup-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.data_archive_bucket_v2.id
}

resource "aws_ssm_parameter" "jira_key" {
  name  = "kubernetes-jira-backup-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.data_archive_bucket_v2.secret
}
