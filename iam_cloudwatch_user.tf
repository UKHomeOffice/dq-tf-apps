resource "aws_iam_user" "cloud_watch_log_user" {
  name = "iam-cloud-watch-user-${local.naming_suffix}"
}

resource "aws_iam_group" "cloud_watch_log_group" {
  name = "iam-cloud-watch-log-group-${local.naming_suffix}"
}

resource "aws_iam_policy" "cloud_watch_log_policy" {
  name = "iam-policy-cloud-watch-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
        ],
        "Resource": [
            "*"
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

resource "aws_iam_group_policy_attachment" "cloud_watch_log_policy" {
  group      = aws_iam_group.cloud_watch_log_group.name
  policy_arn = aws_iam_policy.cloud_watch_log_policy.arn
}

resource "aws_iam_group_membership" "cloud_watch_log" {
  name  = "iam-group-membership-cloud-watch-log-${local.naming_suffix}"
  users = [aws_iam_user.cloud_watch_log_user.name]
  group = aws_iam_group.cloud_watch_log_group.name
}
