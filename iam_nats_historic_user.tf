resource "aws_iam_group" "nats_history" {
  name = "iam-group-nats-history-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "nats_history" {
  name = "iam-group-membership-nats-history-${local.naming_suffix}"

  users = [
    "${aws_iam_user.nats_history.name}",
  ]

  group = "${aws_iam_group.nats_history.name}"
}

resource "aws_iam_group_policy" "nats_history" {
  name  = "iam-group-policy-nats-history-${local.naming_suffix}"
  group = "${aws_iam_group.nats_history.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "${aws_s3_bucket.nats_archive_bucket.arn}",
        "${aws_s3_bucket.nats_archive_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.nats_internal_bucket.arn}/${var.namespace == "prod" ? "newprocessed" : "processed"}/fpl/*"
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
      "Resource": "${aws_kms_key.bucket_key.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_user" "nats_history" {
  name = "iam-user-nats-history-${local.naming_suffix}"
}

resource "aws_iam_access_key" "nats_history" {
  user = "${aws_iam_user.nats_history.name}"
}

resource "aws_ssm_parameter" "nats_history_id" {
  name  = "nats-history-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = "${aws_iam_access_key.nats_history.id}"
}

resource "aws_ssm_parameter" "nats_history_key" {
  name  = "nats-history-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = "${aws_iam_access_key.nats_history.secret}"
}
