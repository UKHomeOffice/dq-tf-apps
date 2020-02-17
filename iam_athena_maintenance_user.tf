resource "aws_iam_group" "athena_adhoc_maintenance_database" {
  name = "iam-group-athena-maintenance-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "athena_maintenance" {
  name = "iam-group-membership-athena-maintenance-${local.naming_suffix}"

  users = [
    "${aws_iam_user.athena_maintenance.name}",
  ]

  group = "${aws_iam_group.athena_maintenance.name}"
}

resource "aws_iam_group_policy" "athena_maintenance" {
  name  = "iam-group-policy-athena-maintenance-${local.naming_suffix}"
  group = "${aws_iam_group.athena_maintenance.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Action": [
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.athena_maintenance_bucket}",
        "${var.athena_maintenance_bucket}/*"
      ]
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
        "${join("\",\"", formatlist("arn:aws:s3:::%s-%s", var.dq_pipeline_ops_readwrite_bucket_list, var.namespace))}",
        "${join("\",\"", formatlist("arn:aws:s3:::%s-%s/*", var.dq_pipeline_ops_readwrite_bucket_list, var.namespace))}"
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
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetPartition",
        "glue:GetPartitions",
        "glue:CreatePartition",
        "glue:DeletePartition",
        "glue:BatchDeletePartition",
        "glue:BatchCreatePartition"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:catalog",
        "${join("\",\"", formatlist("arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s_%s", var.dq_pipeline_ops_readwrite_database_name_list, var.namespace))}",
        "${join("\",\"", formatlist("arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s_%s/*", var.dq_pipeline_ops_readwrite_database_name_list, var.namespace))}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": [
        "arn:aws:ssm:eu-west-2:*:parameter/slack_notification_webhook"
      ]
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

resource "aws_iam_user" "athena_maintenance" {
  name = "iam-user-athena-maintenance-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena_maintenance" {
  user = "${aws_iam_user.athena_maintenance.name}"
}

resource "aws_ssm_parameter" "athena_maintenance_id" {
  name  = "kubernetes-athena-maintenance-user-id-${var.athena_log_prefix}-${local.naming_suffix}"
  type  = "SecureString"
  value = "${aws_iam_access_key.athena_maintenance.id}"
}

resource "aws_ssm_parameter" "athena_maintenance_key" {
  name  = "kubernetes-athena-maintenance-user-key-${var.athena_log_prefix}-${local.naming_suffix}"
  type  = "SecureString"
  value = "${aws_iam_access_key.athena_maintenance.secret}"
}
