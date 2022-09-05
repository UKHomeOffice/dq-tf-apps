resource "aws_iam_group" "vault_admin" {
  name = "iam-group-vault-admin"
}

resource "aws_iam_group_membership" "vault_admin" {
  name = "iam-group-membership-vault-admin"

  users = [
    aws_iam_user.vault_admin.name,
  ]

  group = aws_iam_group.vault_admin.name
}

resource "aws_iam_policy" "vault_admin" {
  name = "iam-policy-vault-admin"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "iam:AttachUserPolicy",
          "iam:CreateAccessKey",
          "iam:CreateUser",
          "iam:DeleteAccessKey",
          "iam:DeleteUser",
          "iam:DeleteUserPolicy",
          "iam:DetachUserPolicy",
          "iam:ListAccessKeys",
          "iam:ListAttachedUserPolicies",
          "iam:ListGroupsForUser",
          "iam:ListUserPolicies",
          "iam:PutUserPolicy",
          "iam:AddUserToGroup",
          "iam:RemoveUserFromGroup",
          "iam:GetUser"
        ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "vault_admin" {
  group      = aws_iam_group.vault_admin.name
  policy_arn = aws_iam_policy.vault_admin.arn
}

resource "aws_iam_user" "vault_admin" {
  name = "iam-user-vault-admin"
}

// resource "aws_iam_access_key" "vault_admin" {
//   user = aws_iam_user.vault_admin.name
// }

// resource "aws_ssm_parameter" "vault_admin_id" {
//   name  = "vault-admin-user-id"
//   type  = "SecureString"
//   value = aws_iam_access_key.vault_admin.id
// }

// resource "aws_ssm_parameter" "vault_admin_key" {
//   name  = "vault-admin-user-key"
//   type  = "SecureString"
//   value = aws_iam_access_key.vault_admin.secret
// }
