resource "aws_iam_group" "rmr" {
  name = "iam-group-rmr-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "rmr" {
  name = "iam-group-membership-rmr-${local.naming_suffix}"

  users = [
    "${aws_iam_user.rmr.name}",
  ]

  group = "${aws_iam_group.rmr.name}"
}

resource "aws_iam_group_policy" "rmr" {
  name  = "rmr-group-policy-${local.naming_suffix}"
  group = "${aws_iam_group.rmr.id}"

  policy = <<EOF

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketAcl"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.data_archive_bucket.arn}"
    },
  ]
}
EOF
}

resource "aws_iam_user" "rmr" {
  name = "iam-user-rmr-${local.naming_suffix}"
}

resource "aws_iam_access_key" "rmr" {
  user = "${aws_iam_user.rmr.name}"
}
