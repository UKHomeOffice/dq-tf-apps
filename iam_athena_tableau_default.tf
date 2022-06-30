resource "aws_iam_group" "athena_tableau_default" {
  name = "iam-group-athena-tableau-default-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "athena_tableau_default" {
  name = "iam-group-membership-athena-tableau-default-${local.naming_suffix}"

  users = [
    aws_iam_user.athena_tableau_default.name,
  ]

  group = aws_iam_group.athena_tableau_default.name
}

resource "aws_iam_policy" "athena_tableau_default" {
  name = "iam-policy-athena-tableau-default-${local.naming_suffix}"
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

resource "aws_iam_group_policy_attachment" "athena_tableau_default" {
  group      = aws_iam_group.athena_tableau_default.name
  policy_arn = aws_iam_policy.athena_tableau_default.arn
}

resource "aws_iam_policy" "athena_tableau_glue_default" {
  name = "iam-policy-athena-tableau-glue-default-${local.naming_suffix}"

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
    var.default_athena,
    var.namespace,
    ),
  )}",
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s_%s/*",
    var.default_athena,
    var.namespace,
  ),
)}"
        ]
     }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "athena_tableau_glue_default" {
  group      = aws_iam_group.athena_tableau_default.name
  policy_arn = aws_iam_policy.athena_tableau_glue_default.arn
}

resource "aws_iam_user" "athena_tableau_default" {
  name = "iam-user-athena-tableau-default-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena_tableau_default" {
  user = aws_iam_user.athena_tableau_default.name
}

resource "aws_ssm_parameter" "athena_tableau_id_default" {
  name  = "tableau-athena-user-id-default-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_tableau_default.id
}

resource "aws_ssm_parameter" "athena_tableau_default_key" {
  name  = "tableau-athena-user-key-default-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_tableau_default.secret
}
