resource "aws_iam_group" "nats" {
  name = "iam-group-nats-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "nats" {
  name = "iam-group-membership-nats-${local.naming_suffix}"

  users = [
    aws_iam_user.nats.name,
  ]

  group = aws_iam_group.nats.name
}

resource "aws_iam_group_policy" "nats" {
  name  = "group-policy-nats-${local.naming_suffix}"
  group = aws_iam_group.nats.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": [
        "${aws_s3_bucket.data_archive_bucket.arn}",
        "${aws_s3_bucket.nats_archive_bucket.arn}"
        ]
    },
    {
      "Sid": "PutS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.data_archive_bucket.arn}/*",
        "${aws_s3_bucket.nats_archive_bucket.arn}/*"
        ]
    },
    {
      "Sid": "UseKMSKey",
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

resource "aws_iam_user" "nats" {
  name = "iam-user-nats-${local.naming_suffix}"
}

resource "aws_iam_access_key" "nats" {
  user = aws_iam_user.nats.name
}

resource "aws_ssm_parameter" "nats_id" {
  name  = "kubernetes-nats-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.nats.id
}

resource "aws_ssm_parameter" "nats_key" {
  name  = "kubernetes-nats-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.nats.secret
}
