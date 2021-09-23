resource "aws_iam_group" "rds_maintenance" {
  name = "iam-group-rds-maintenance-${local.naming_suffix}"
}

resource "aws_iam_user" "rds_maintenance" {
  name = "iam-user-rds-maintenance-${local.naming_suffix}"
}

resource "aws_iam_access_key" "rds_maintenance" {
  user = aws_iam_user.rds_maintenance.name
}

resource "aws_iam_group_membership" "rds_maintenance" {
  name = "iam-group-membership-rds-maintenance-${local.naming_suffix}"

  users = [
    aws_iam_user.rds_maintenance.name,
  ]

  group = aws_iam_group.rds_maintenance.name
}

resource "aws_iam_policy" "lambda_policy_rds_maintenance" {
  name = "iam-policy-rds-maintenance-${local.naming_suffix}"

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

resource "aws_iam_group_policy_attachment" "rds_maintenance" {
  group      = aws_iam_group.rds_maintenance.name
  policy_arn = aws_iam_policy.lambda_policy_rds_maintenance.arn
}

resource "aws_ssm_parameter" "rds_maintenance_id" {
  name  = "kubernetes-rds-maintenance-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.rds_maintenance.id
}

resource "aws_ssm_parameter" "rds_maintenance_key" {
  name  = "kubernetes-rds-maintenance-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.rds_maintenance.secret
}
