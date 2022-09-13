resource "aws_iam_group" "monitor" {
  name = "iam-group-monitor-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "monitor" {
  name = "iam-group-membership-monitor-${local.naming_suffix}"

  users = [
    aws_iam_user.monitor.name,
  ]

  group = aws_iam_group.monitor.name
}

resource "aws_iam_policy" "monitor_athena" {
  name = "iam-policy-monitor-athena-${local.naming_suffix}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
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
        "${aws_s3_bucket.athena_log_bucket.arn}",
        "${aws_s3_bucket.athena_log_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:s3:::%s-%s",
    var.dq_pipeline_ops_readwrite_bucket_list,
    var.namespace,
  ),
  )}",
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:s3:::%s-%s/*",
    var.dq_pipeline_ops_readwrite_bucket_list,
    var.namespace,
  ),
)}"
      ]
    },
    {
      "Action": [
        "athena:StartQueryExecution",
        "athena:GetQueryExecution",
        "athena:GetQueryResults",
        "athena:GetQueryResultsStream",
        "athena:UpdateWorkGroup",
        "athena:GetWorkGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.bucket_key.arn}"
    }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "monitor_athena" {
  group      = aws_iam_group.monitor.name
  policy_arn = aws_iam_policy.monitor_athena.arn
}

resource "aws_iam_policy" "monitor_glue" {
  name = "iam-policy-monitor-glue-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
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
      "Resource": [
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:catalog",
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s_%s",
    var.dq_pipeline_athena_readwrite_database_name_list,
    var.namespace,
    ), formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s",
    var.dq_pipeline_athena_unscoped_readwrite_database_name_list,
  ),
  )}",
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s_%s/*",
    var.dq_pipeline_athena_readwrite_database_name_list,
    var.namespace,
    ), formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s/*",
    var.dq_pipeline_athena_unscoped_readwrite_database_name_list,
  ),
)}"
        ]
     }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "monitor_glue" {
  group      = aws_iam_group.monitor.name
  policy_arn = aws_iam_policy.monitor_glue.arn
}

resource "aws_iam_policy" "monitor_ssm" {
  name = "iam-policy-monitor-ssm-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
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
          "${aws_kms_key.bucket_key.arn}"
        ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:Describe*",
        "ssm:Get*",
        "ssm:List*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "monitor_ssm" {
  group      = aws_iam_group.monitor.name
  policy_arn = aws_iam_policy.monitor_ssm.arn
}

resource "aws_iam_group_policy_attachment" "monitor_cw" {
  group      = aws_iam_group.monitor.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

resource "aws_iam_user" "monitor" {
  name = "iam-user-monitor-${local.naming_suffix}"
}
