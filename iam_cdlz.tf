resource "aws_iam_group" "cdlz" {
  name = "iam-group-cdlz-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "cdlz" {
  name = "iam-group-membership-cdlz-${local.naming_suffix}"

  users = [
    "${aws_iam_user.cdlz.name}",
  ]

  group = "${aws_iam_group.cdlz.name}"
}

resource "aws_iam_group_policy" "freight" {
  name  = "group-policy-cdlz-${local.naming_suffix}"
  group = "${aws_iam_group.cdlz.id}"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListS3Bucket",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::s3-dq-freight-archive-prod"
        },
        {
            "Sid": "PutS3Bucket",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::s3-dq-freight-archive-prod/archive/*"
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
            "Resource": "arn:aws:kms:eu-west-2:337779336338:key/ae75113d-f4f6-49c6-a15e-e8493fda0453"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy" "api" {
  name  = "group-policy-cdlz-${local.naming_suffix}"
  group = "${aws_iam_group.cdlz.id}"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListS3Bucket",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::s3-dq-api-archive-prod"
        },
        {
            "Sid": "PutS3Bucket",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::s3-dq-api-archive-prod/*"
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
            "Resource": "arn:aws:kms:eu-west-2:337779336338:key/ae75113d-f4f6-49c6-a15e-e8493fda0453"
        }
    ]
}
EOF
}

resource "aws_iam_user" "cdlz" {
  name = "iam-user-cdlz-${local.naming_suffix}"
}

resource "aws_iam_access_key" "cdlz" {
  user = "${aws_iam_user.cdlz.name}"
}
