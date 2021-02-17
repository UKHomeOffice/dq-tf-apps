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

resource "aws_iam_group_policy_attachment" "athena_tableau_fedat" {
  group      = aws_iam_group.athena_tableau_fedat.name
  policy_arn = aws_iam_policy.athena_tableau_fedat.arn
}

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
