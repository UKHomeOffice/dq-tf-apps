resource "aws_iam_group" "athena_tableau" {
  name = "iam-group-athena-tableau-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "athena_tableau" {
  name = "iam-group-membership-athena-tableau-${local.naming_suffix}"

  users = [
    aws_iam_user.athena_tableau.name,
  ]

  group = aws_iam_group.athena_tableau.name
}

resource "aws_iam_policy" "athena_tableau" {
  name = "iam-policy-athena-tableau-${local.naming_suffix}"
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

resource "aws_iam_group_policy_attachment" "athena_tableau" {
  group      = aws_iam_group.athena_tableau.name
  policy_arn = aws_iam_policy.athena_tableau.arn
}

resource "aws_iam_policy" "athena_tableau_glue" {
  name = "iam-policy-athena-tableau-glue-${local.naming_suffix}"

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

resource "aws_iam_group_policy_attachment" "athena_tableau_glue" {
  group      = aws_iam_group.athena_tableau.name
  policy_arn = aws_iam_policy.athena_tableau_glue.arn
}

resource "aws_iam_user" "athena_tableau" {
  name = "iam-user-athena-tableau-${local.naming_suffix}"
}
