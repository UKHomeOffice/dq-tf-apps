resource "aws_iam_group" "oag" {
  name = "iam-group-oag-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "oag" {
  name = "iam-group-membership-oag-${local.naming_suffix}"

  users = [
    aws_iam_user.oag.name,
  ]

  group = aws_iam_group.oag.name
}

resource "aws_iam_policy" "oag" {
  name = "iam-policy-oag-${local.naming_suffix}"

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
        "${aws_s3_bucket.oag_archive_bucket.arn}"
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
        "${aws_s3_bucket.oag_archive_bucket.arn}/*"
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

resource "aws_iam_group_policy_attachment" "oag" {
  group      = aws_iam_group.oag.name
  policy_arn = aws_iam_policy.oag.arn
}

resource "aws_iam_user" "oag" {
  name = "iam-user-oag-${local.naming_suffix}"
}

// resource "aws_iam_access_key" "oag" {
//   user = aws_iam_user.oag.name
// }

// resource "aws_ssm_parameter" "oag_id" {
//   name  = "kubernetes-oag-user-id-${local.naming_suffix}"
//   type  = "SecureString"
//   value = aws_iam_access_key.oag.id
// }

// resource "aws_ssm_parameter" "oag_key" {
//   name  = "kubernetes-oag-user-key-${local.naming_suffix}"
//   type  = "SecureString"
//   value = aws_iam_access_key.oag.secret
// }
