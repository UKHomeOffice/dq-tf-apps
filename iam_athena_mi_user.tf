resource "aws_iam_policy" "athena_mi_user" {
  name = "athena_mi_user_policy"
  
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "athena:StartQueryExecution",
                "athena:GetQueryExecution",
                "athena:GetQueryResults",
                "athena:GetQueryResultsStream",
                "athena:UpdateWorkGroup",
                "athena:GetWorkGroup",
                "athena:CreatePreparedStatement"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::test-flightstats-non-prod",
                "arn:aws:s3:::test-flightstats-non-prod/*"
            ]
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
                "glue:GetPartitions",
                "glue:BatchGetPartition"
            ],
            "Effect": "Allow",
            "Resource": "mi_reporting"
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

resource "aws_iam_group_policy_attachment" "athena_mi_user" {
  group      = aws_iam_group.athena_mi_user.name
  policy_arn = aws_iam_policy.athena_mi_user.arn
}

resource "aws_iam_user" "athena_mi_user" {
  name = "athena_mi_user"
}


resource "aws_iam_access_key" "athena_mi_user" {
  user = aws_iam_user.athena_mi_user.name
}

resource "aws_iam_group" "athena_mi_user" {
  name = "athena_mi_user"
}

resource "aws_iam_group_membership" "athena_mi_user" {
  name = "athena_mi_user"

  users = [aws_iam_user.athena_mi_user.name]

  group = aws_iam_group.athena_mi_user.name
}

resource "aws_ssm_parameter" "athena_mi_user_id" {
  name  = "athena-mi-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_mi_user.id
}

resource "aws_ssm_parameter" "athena_mi_user_key" {
  name  = "athena-mi-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_mi_user.secret
}
