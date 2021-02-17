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
