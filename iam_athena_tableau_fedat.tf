resource "aws_iam_user" "athena_tableau_fedat" {
  name = "iam-user-athena-tableau-fedat-${local.naming_suffix}"
}
