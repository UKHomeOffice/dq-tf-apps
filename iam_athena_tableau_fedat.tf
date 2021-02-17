resource "aws_iam_group" "athena_tableau_fedat" {
  name = "iam-group-athena-tableau-fedat-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "athena_tableau_fedat" {
  name = "iam-group-membership-athena-tableau-fedat-${local.naming_suffix}"

  users = [
    aws_iam_user.athena_tableau_fedat.name,
  ]

  group = aws_iam_group.athena_tableau_fedat.name
}

# resource "aws_iam_group_policy" "athena_tableau_fedat" {
#   name  = "iam-group-policy-athena-tableau-fedat-${local.naming_suffix}"
#   group = aws_iam_group.athena_tableau_fedat.id
#
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#   {
#       "Action": [
#         "s3:GetBucketLocation",
#         "s3:GetObject",
#         "s3:ListBucket",
#         "s3:ListBucketMultipartUploads",
#         "s3:ListMultipartUploadParts",
#         "s3:AbortMultipartUpload",
#         "s3:PutObject",
#         "s3:DeleteObject"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.athena_log_bucket.arn}",
#         "${aws_s3_bucket.athena_log_bucket.arn}/*"
#       ]
#     },
#     {
#       "Action": [
#         "athena:StartQueryExecution",
#         "athena:GetQueryExecution",
#         "athena:GetQueryResults",
#         "athena:GetQueryResultsStream",
#         "athena:UpdateWorkGroup",
#         "athena:GetWorkGroup"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     },
#     {
#       "Action": [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_kms_key.bucket_key.arn}"
#     }
#   ]
# }
# EOF
#
# }

# resource "aws_iam_policy" "athena_tableau_fedat" {
#   name = "iam-policy-athena-tableau-fedat-${local.naming_suffix}"
#
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [{
#       "Action": [
#         "glue:GetDatabase",
#         "glue:GetDatabases",
#         "glue:GetTable",
#         "glue:GetTables",
#         "glue:GetPartition",
#         "glue:GetPartitions",
#         "glue:BatchGetPartition"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:catalog",
#         "${join(
#   "\",\"",
#   formatlist(
#     "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:database/%s_%s",
#     var.dq_pipeline_athena_readwrite_database_name_list_fedat,
#   ),
#   )}",
#         "${join(
#   "\",\"",
#   formatlist(
#     "arn:aws:glue:eu-west-2:${data.aws_caller_identity.current.account_id}:table/%s_%s/*",
#     var.dq_pipeline_athena_readwrite_database_name_list_fedat,
#   ),
# )}"
#         ]
#      }
#   ]
# }
# EOF
#
# }

# resource "aws_iam_group_policy_attachment" "athena_tableau_fedat" {
#   group      = aws_iam_group.athena_tableau_fedat.name
#   policy_arn = aws_iam_policy.athena_tableau_fedat.arn
# }

resource "aws_iam_user" "athena_tableau_fedat" {
  name = "iam-user-athena-tableau-fedat-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena_tableau_fedat" {
  user = aws_iam_user.athena_tableau_fedat.name
}

resource "aws_ssm_parameter" "athena_tableau_fedat_id" {
  name  = "tableau-athena-fedat-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_tableau_fedat.id
}

resource "aws_ssm_parameter" "athena_tableau_fedat_key" {
  name  = "tableau-athena-fedat-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.athena_tableau_fedat.secret
}
