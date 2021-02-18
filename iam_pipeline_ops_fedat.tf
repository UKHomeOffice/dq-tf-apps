resource "aws_iam_policy" "dq_pipeline_ops_fedat_policy" {
  name = "dq-pipeline-ops-policy-${var.namespace}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "glue:GetDatabase",
        "glue:GetDatabases",
        "glue:CreateTable",
        "glue:DeleteTable",
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetPartition",
        "glue:GetPartitions",
        "glue:BatchCreatePartition",
        "glue:BatchDeletePartition"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:catalog",
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s",
    var.dq_pipeline_ops_readwrite_database_name_list_fedat,
  ),
  )}",
        "${join(
  "\",\"",
  formatlist(
    "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s/*",
    var.dq_pipeline_ops_readwrite_database_name_list_fedat,
  ),
)}"
      ]
    },
    {
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ],
      "Effect": "Allow",
      "Resource": "${data.aws_kms_key.glue.arn}"
    },
    {
      "Action": [
        "states:List*",
        "states:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_group" "dq_pipeline_ops_fedat_group" {
  name = "dq-pipeline-ops-fedat${var.namespace}"
}

resource "aws_iam_group_policy_attachment" "dq_pipeline_ops_fedat_attachment" {
  group      = aws_iam_group.dq_pipeline_ops_fedat_group.name
  policy_arn = aws_iam_policy.dq_pipeline_ops_fedat_policy.arn
}
