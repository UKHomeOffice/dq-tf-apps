resource "aws_iam_group" "acl" {
  name = "iam-group-acl-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "acl" {
  name = "iam-group-membership-acl-${local.naming_suffix}"

  users = [
    aws_iam_user.acl.name,
  ]

  group = aws_iam_group.acl.name
}

resource "aws_iam_policy" "acl" {
  name = "iam-policy-acl-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": [
        "${module.data_ingest.data_landing_bucket_arn}",
        "${aws_s3_bucket.acl_archive_bucket.arn}"
      ]
    },
    {
      "Sid": "PutS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "${module.data_ingest.data_landing_bucket_arn}/*",
        "${aws_s3_bucket.acl_archive_bucket.arn}/*"
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
        "Resource": [
          "${module.data_ingest.data_landing_bucket_key_arn}",
          "${aws_kms_key.bucket_key.arn}"
          ]
    }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "acl" {
  group      = aws_iam_group.acl.name
  policy_arn = aws_iam_policy.acl.arn
}

resource "aws_iam_user" "acl" {
  name = "iam-user-acl-${local.naming_suffix}"
}
