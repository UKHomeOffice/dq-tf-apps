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

resource "aws_iam_group_policy" "athena_tableau" {
  name  = "iam-group-policy-athena-tableau-${local.naming_suffix}"
  group = aws_iam_group.athena_tableau.id

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
        "s3:AbortMultipartUpload"
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

resource "aws_iam_user" "athena_tableau" {
  name = "iam-user-athena-tableau-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena_tableau" {
  user = aws_iam_user.athena_tableau.name
}

resource "aws_ssm_parameter" "athena_tableau_id" {
  name  = "tableau-athena-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_tableau.id
}

resource "aws_ssm_parameter" "athena_tableau_key" {
  name  = "tableau-athena-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_tableau.secret
}
