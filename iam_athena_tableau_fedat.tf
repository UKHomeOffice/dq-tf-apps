resource "aws_iam_user" "athena_tableau_fedat" {
  name = "iam-user-athena-tableau-fedat-${local.naming_suffix}"
}

resource "aws_iam_access_key" "athena_tableau_fedat" {
  user = aws_iam_user.athena_tableau_fedat.name
}
