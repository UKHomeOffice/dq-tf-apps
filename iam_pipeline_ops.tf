resource "aws_iam_policy" "dq_pipeline_ops_policy" {
  name = "dq-pipeline-ops-policy-${var.namespace}"

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
        "${join("\",\"", formatlist("arn:aws:s3:::%s-%s", var.dq_pipeline_ops_readwrite_bucket_list, var.namespace))}",
        "${join("\",\"", formatlist("arn:aws:s3:::%s-%s/*", var.dq_pipeline_ops_readwrite_bucket_list, var.namespace))}"
      ]
    },
    {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "*" 
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
        "${join("\",\"", formatlist("arn:aws:s3:::%s-%s", var.dq_pipeline_ops_readonly_bucket_list, var.namespace))}",
        "${join("\",\"", formatlist("arn:aws:s3:::%s-%s/*", var.dq_pipeline_ops_readonly_bucket_list, var.namespace))}"
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
        "${join("\",\"", formatlist("arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s_%s", var.dq_pipeline_ops_readwrite_database_name_list, var.namespace))}",
        "${join("\",\"", formatlist("arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s_%s/*", var.dq_pipeline_ops_readwrite_database_name_list, var.namespace))}"
      ]
    },
    {
      "Action": [
        "glue:GetDatabase",
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetPartition",
        "glue:GetPartitions"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/default",
        "${join("\",\"", formatlist("arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s_%s", var.dq_pipeline_ops_readonly_database_name_list, var.namespace))}",
        "${join("\",\"", formatlist("arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s_%s/*", var.dq_pipeline_ops_readonly_database_name_list, var.namespace))}"
      ]
    },
    {
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.bucket_key.arn}"
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

resource "aws_iam_group" "dq_pipeline_ops_group" {
  name = "dq-pipeline-ops-${var.namespace}"
}

resource "aws_iam_group_policy_attachment" "dq_pipeline_ops_attachment" {
  group      = "${aws_iam_group.dq_pipeline_ops_group.name}"
  policy_arn = "${aws_iam_policy.dq_pipeline_ops_policy.arn}"
}
