resource "aws_iam_group" "rds_crt" {
  name = "iam-group-rds-crt-${local.naming_suffix}"
}

resource "aws_iam_user" "rds_crt" {
  name = "iam-user-rds-crt-${local.naming_suffix}"
}

resource "aws_iam_access_key" "rds_crt" {
  user = aws_iam_user.rds_crt.name
}

resource "aws_iam_group_membership" "rds_crt" {
  name = "iam-group-membership-rds-crt-${local.naming_suffix}"

  users = [
    aws_iam_user.rds_crt.name,
  ]

  group = aws_iam_group.rds_crt.name
}

resource "aws_iam_policy" "dimensiondata_policy_rds_crt" {
  name = "iam-policy-rds-crt-${local.naming_suffix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameters"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_fms_username",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_fms_password",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_internal_tableau_username",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_internal_tableau_password",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_datafeed_username",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_datafeed_password",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/slack_notification_webhook"
        ]
    }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "rds_crt" {
  group      = aws_iam_group.rds_crt.name
  policy_arn = aws_iam_policy.dimensiondata_policy_rds_crt.arn
}

resource "aws_ssm_parameter" "rds_crt_id" {
  name  = "Dimension-data-rds-crt-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.rds_crt.id
}

resource "aws_ssm_parameter" "rds_crt_key" {
  name  = "Dimension-data-rds-crt-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.rds_crt.secret
}
