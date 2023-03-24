resource "aws_iam_policy" "athena_readonly_user" {
  name = "athena_readonly_user_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "athena:StartQueryExecution",
                "athena:GetQueryExecution",
                "athena:GetQueryResults",
                "athena:GetQueryResultsStream"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:PutBucketPublicAccessBlock"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::s3-dq-athena-log-${var.namespace}",
                "arn:aws:s3:::s3-dq-athena-log-${var.namespace}/*"
            ]
        },
        {
            "Action": [
                "glue:GetDatabase",
                "glue:GetDatabases",
                "glue:GetTable",
                "glue:GetTables",
                "glue:GetPartition",
                "glue:GetPartitions"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Effect": "Allow",
            "Resource": "${var.kms_key_s3[var.namespace]}"
        },
        {
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Effect": "Allow",
            "Resource": "${data.aws_kms_key.glue.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "athena_readonly_user" {
  group      = aws_iam_group.athena_readonly_user.name
  policy_arn = aws_iam_policy.athena_readonly_user.arn
}

resource "aws_iam_user" "athena_readonly_user" {
  name = "athena_readonly_user"
}


resource "aws_iam_access_key" "athena_readonly_user" {
  user = aws_iam_user.athena_readonly_user.name
}

resource "aws_iam_group" "athena_readonly_user" {
  name = "athena_readonly_user"
}

resource "aws_iam_group_membership" "athena_readonly_user" {
  name = "athena_readonly_user"

  users = [aws_iam_user.athena_readonly_user.name]

  group = aws_iam_group.athena_readonly_user.name
}

resource "aws_ssm_parameter" "athena_readonly_user_id" {
  name  = "athena-readonly-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_readonly_user.id
}

resource "aws_ssm_parameter" "athena_readonly_user_key" {
  name  = "athena-readonly-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_readonly_user.secret
}
