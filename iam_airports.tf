resource "aws_iam_group" "airports" {
  name = "iam-group-airports-${local.naming_suffix}"
}

resource "aws_iam_policy" "airports" {
  name = "iam-group-policy-airports-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.airports_archive_bucket.arn}"
    },
    {
      "Sid": "PutS3Bucket",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.airports_archive_bucket.arn}/*"
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

resource "aws_iam_group_policy_attachment" "airports" {
  group      = aws_iam_group.airports.name
  policy_arn = aws_iam_policy.airports.arn
}
