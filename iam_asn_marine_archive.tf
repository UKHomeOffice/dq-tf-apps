resource "aws_iam_group_policy" "dq_asn_marine_archive_bucket_policy" {
  name  = "dq_asn_marine_archive_bucket_policy"
  group = aws_iam_group.dq_asn_marine_archive_bucket.id

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
        "${aws_s3_bucket.dq_asn_marine_archive_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.dq_asn_marine_archive_bucket.arn}/*"
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
          "${aws_s3_bucket.dq_asn_marine_archive_bucket.arn}"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_user" "dq_asn_marine_archive_bucket" {
  name = "dq_asn_marine_archive_bucket_user"
}


resource "aws_iam_access_key" "dq_asn_marine_archive_bucket" {
  user = aws_iam_user.dq_asn_marine_archive_bucket.name
}

resource "aws_iam_group" "dq_asn_marine_archive_bucket" {
  name = "dq_asn_marine_archive_bucket"
}

resource "aws_iam_group_membership" "dq_asn_marine_archive_bucket" {
  name = "dq_asn_marine_archive_bucket"

  users = [aws_iam_user.dq_asn_marine_archive_bucket.name]

  group = aws_iam_group.dq_asn_marine_archive_bucket.name
}

resource "aws_ssm_parameter" "dq_asn_marine_archive_bucket_id" {
  name  = "asn-marine-archive-bucket-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_asn_marine_archive_bucket.id
}

resource "aws_ssm_parameter" "dq_asn_marine_archive_bucket_key" {
  name  = "asn-marine-archive-bucket-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.dq_asn_marine_archive_bucket.secret
}

