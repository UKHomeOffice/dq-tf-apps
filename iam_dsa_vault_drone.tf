resource "aws_iam_group" "vault_drone" {
  name = "iam-group-vault-admin-${local.naming_suffix}"
}

resource "aws_iam_group_membership" "vault_drone" {
  name = "iam-group-membership-vault-admin-${local.naming_suffix}"

  users = [
    aws_iam_user.vault_drone.name,
  ]

  group = aws_iam_group.vault_drone.name
}

variable "vault_drone_managed_policies" {
  type = list
  default = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AWSDirectoryServiceFullAccess",
    "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser",
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  ]
}

resource "aws_iam_group_policy_attachment" "vault_drone" {
  count      = length(var.vault_drone_managed_policies)
  group      = aws_iam_group.vault_drone.name
  policy_arn = var.vault_drone_managed_policies[count.index]
}

resource "aws_iam_user" "vault_drone" {
  name = "iam-user-vault-admin-${local.naming_suffix}"
}

resource "aws_iam_access_key" "vault_drone" {
  user = aws_iam_user.vault-admin.name
}

resource "aws_ssm_parameter" "vault_drone_id" {
  name  = "vault-admin-user-id-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.vault-admin.id
}

resource "aws_ssm_parameter" "vault_drone_key" {
  name  = "vault-admin-user-key-${local.naming_suffix}"
  type  = "SecureString"
  value = aws_iam_access_key.vault-admin.secret
}
