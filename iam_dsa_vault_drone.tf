resource "aws_iam_group" "vault_drone" {
  name = "iam-group-vault-drone"
}

resource "aws_iam_policy" "vault_drone_0" {
  name = "iam-vault-drone-policy-0"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3FullAccess",
      "Effect": "Allow",
      "Action":  [
                "s3:*",
                "s3-object-lambda:*"
            ],
      "Resource": "*"
    },
    {
       "Sid": "EC2FullAccess",
       "Action": "ec2:*",
       "Effect": "Allow",
       "Resource": "*"
    },
    {
       "Sid": "ELBFullAccess",
       "Effect": "Allow",
       "Action": "elasticloadbalancing:*",
       "Resource": "*"
    },
    {
       "Sid": "CWFullAccess",
       "Effect": "Allow",
       "Action": "cloudwatch:*",
       "Resource": "*"
    },
    {
       "Sid": "ASGFullAccess",
       "Effect": "Allow",
       "Action": "autoscaling:*",
       "Resource": "*"
    },
    {
       "Sid": "EC2IAMFullAccess",
       "Effect": "Allow",
       "Action": "iam:CreateServiceLinkedRole",
       "Resource": "*",
       "Condition": {
           "StringEquals": {
               "iam:AWSServiceName": [
                   "autoscaling.amazonaws.com",
                   "ec2scheduled.amazonaws.com",
                   "elasticloadbalancing.amazonaws.com",
                   "spot.amazonaws.com",
                   "spotfleet.amazonaws.com",
                   "transitgateway.amazonaws.com"
               ]
           }
       }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "vault_drone_1" {
  name = "iam-vault-drone-policy-1"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RDSFullAccess",
       "Action": [
           "rds:*",
           "application-autoscaling:DeleteScalingPolicy",
           "application-autoscaling:DeregisterScalableTarget",
           "application-autoscaling:DescribeScalableTargets",
           "application-autoscaling:DescribeScalingActivities",
           "application-autoscaling:DescribeScalingPolicies",
           "application-autoscaling:PutScalingPolicy",
           "application-autoscaling:RegisterScalableTarget",
           "cloudwatch:DescribeAlarms",
           "cloudwatch:GetMetricStatistics",
           "cloudwatch:PutMetricAlarm",
           "cloudwatch:DeleteAlarms",
           "ec2:DescribeAccountAttributes",
           "ec2:DescribeAvailabilityZones",
           "ec2:DescribeCoipPools",
           "ec2:DescribeInternetGateways",
           "ec2:DescribeLocalGatewayRouteTables",
           "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
           "ec2:DescribeLocalGateways",
           "ec2:DescribeSecurityGroups",
           "ec2:DescribeSubnets",
           "ec2:DescribeVpcAttribute",
           "ec2:DescribeVpcs",
           "ec2:GetCoipPoolUsage",
           "sns:ListSubscriptions",
           "sns:ListTopics",
           "sns:Publish",
           "logs:DescribeLogStreams",
           "logs:GetLogEvents",
           "outposts:GetOutpostInstanceTypes"
       ],
       "Effect": "Allow",
       "Resource": "*"
    },
    {
       "Sid": "PIMFullAccess",
       "Action": "pi:*",
       "Effect": "Allow",
       "Resource": "arn:aws:pi:*:*:metrics/rds/*"
    },
    {
      "Sid": "RDSIAMFullAccess",
       "Action": "iam:CreateServiceLinkedRole",
       "Effect": "Allow",
       "Resource": "*",
       "Condition": {
           "StringLike": {
               "iam:AWSServiceName": [
                   "rds.amazonaws.com",
                   "rds.application-autoscaling.amazonaws.com"
               ]
           }
       }
    },
    {
       "Sid": "IAMFullAccess",
       "Effect": "Allow",
       "Action": [
           "iam:*",
           "organizations:DescribeAccount",
           "organizations:DescribeOrganization",
           "organizations:DescribeOrganizationalUnit",
           "organizations:DescribePolicy",
           "organizations:ListChildren",
           "organizations:ListParents",
           "organizations:ListPoliciesForTarget",
           "organizations:ListRoots",
           "organizations:ListPolicies",
           "organizations:ListTargetsForPolicy"
       ],
       "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "vault_drone_2" {
  name = "iam-vault-drone-policy-2"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Sid": "DirectoryServiceFullAccess",
       "Action": [
           "ds:*",
           "ec2:AuthorizeSecurityGroupEgress",
           "ec2:AuthorizeSecurityGroupIngress",
           "ec2:CreateNetworkInterface",
           "ec2:CreateSecurityGroup",
           "ec2:DeleteNetworkInterface",
           "ec2:DeleteSecurityGroup",
           "ec2:DescribeNetworkInterfaces",
           "ec2:DescribeSubnets",
           "ec2:DescribeVpcs",
           "ec2:RevokeSecurityGroupEgress",
           "ec2:RevokeSecurityGroupIngress",
           "ec2:DescribeSecurityGroups",
           "sns:GetTopicAttributes",
           "sns:ListSubscriptions",
           "sns:ListSubscriptionsByTopic",
           "sns:ListTopics",
           "iam:ListRoles",
           "organizations:ListAccountsForParent",
           "organizations:ListRoots",
           "organizations:ListAccounts",
           "organizations:DescribeOrganization",
           "organizations:DescribeAccount",
           "organizations:ListOrganizationalUnitsForParent",
           "organizations:ListAWSServiceAccessForOrganization"
       ],
       "Effect": "Allow",
       "Resource": "*"
    },
    {
       "Sid": "SNSDSFullAccess",
       "Action": [
           "sns:CreateTopic",
           "sns:DeleteTopic",
           "sns:SetTopicAttributes",
           "sns:Subscribe",
           "sns:Unsubscribe"
       ],
       "Effect": "Allow",
       "Resource": "arn:aws:sns:*:*:DirectoryMonitoring*"
    },
    {
       "Sid": "ORGFullAccess",
       "Action": [
           "organizations:EnableAWSServiceAccess",
           "organizations:DisableAWSServiceAccess"
       ],
       "Effect": "Allow",
       "Resource": "*",
       "Condition": {
           "StringEquals": {
               "organizations:ServicePrincipal": "ds.amazonaws.com"
           }
       }
    },
    {
       "Sid": "DSEC2FullAccess",
       "Action": [
           "ec2:CreateTags",
           "ec2:DeleteTags"
       ],
       "Effect": "Allow",
       "Resource": [
           "arn:aws:ec2:*:*:network-interface/*",
           "arn:aws:ec2:*:*:security-group/*"
       ]
    },
    {
       "Sid": "GlueSRFullAccess",
       "Effect": "Allow",
       "Action": [
           "glue:*",
           "s3:GetBucketLocation",
           "s3:ListBucket",
           "s3:ListAllMyBuckets",
           "s3:GetBucketAcl",
           "ec2:DescribeVpcEndpoints",
           "ec2:DescribeRouteTables",
           "ec2:CreateNetworkInterface",
           "ec2:DeleteNetworkInterface",
           "ec2:DescribeNetworkInterfaces",
           "ec2:DescribeSecurityGroups",
           "ec2:DescribeSubnets",
           "ec2:DescribeVpcAttribute",
           "iam:ListRolePolicies",
           "iam:GetRole",
           "iam:GetRolePolicy",
           "cloudwatch:PutMetricData"
       ],
       "Resource": [
           "*"
       ]
    },
    {
       "Sid": "GlueEC2FullAccess",
       "Effect": "Allow",
       "Action": [
           "s3:CreateBucket"
       ],
       "Resource": [
           "arn:aws:s3:::aws-glue-*"
       ]
    },
    {
       "Sid": "GlueS3FullAccess",
       "Effect": "Allow",
       "Action": [
           "s3:GetObject",
           "s3:PutObject",
           "s3:DeleteObject"
       ],
       "Resource": [
           "arn:aws:s3:::aws-glue-*/*",
           "arn:aws:s3:::*/*aws-glue-*/*"
       ]
    },
    {
       "Sid": "GlueS32FullAccess",
       "Effect": "Allow",
       "Action": [
           "s3:GetObject"
       ],
       "Resource": [
           "arn:aws:s3:::crawler-public*",
           "arn:aws:s3:::aws-glue-*"
       ]
    },
    {
       "Sid": "GluelogsFullAccess",
       "Effect": "Allow",
       "Action": [
           "logs:CreateLogGroup",
           "logs:CreateLogStream",
           "logs:PutLogEvents"
       ],
       "Resource": [
           "arn:aws:logs:*:*:/aws-glue/*"
       ]
    },
    {
       "Sid": "GlueEC22FullAccess",
       "Effect": "Allow",
       "Action": [
           "ec2:CreateTags",
           "ec2:DeleteTags"
       ],
       "Condition": {
           "ForAllValues:StringEquals": {
               "aws:TagKeys": [
                   "aws-glue-service-resource"
               ]
           }
       },
       "Resource": [
           "arn:aws:ec2:*:*:network-interface/*",
           "arn:aws:ec2:*:*:security-group/*",
           "arn:aws:ec2:*:*:instance/*"
       ]
    },
    {
       "Sid": "SSMFullAccess",
       "Effect": "Allow",
       "Action": [
           "cloudwatch:PutMetricData",
           "ds:CreateComputer",
           "ds:DescribeDirectories",
           "ec2:DescribeInstanceStatus",
           "logs:*",
           "ssm:*",
           "ec2messages:*"
       ],
       "Resource": "*"
    },
    {
       "Sid": "SSMIAMFullAccess",
       "Effect": "Allow",
       "Action": "iam:CreateServiceLinkedRole",
       "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
       "Condition": {
           "StringLike": {
               "iam:AWSServiceName": "ssm.amazonaws.com"
           }
       }
    },
    {
       "Sid": "SSMIAM2FullAccess",
       "Effect": "Allow",
       "Action": [
           "iam:DeleteServiceLinkedRole",
           "iam:GetServiceLinkedRoleDeletionStatus"
       ],
       "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
    },
    {
       "Sid": "SSMMessageFullAccess",
       "Effect": "Allow",
       "Action": [
           "ssmmessages:CreateControlChannel",
           "ssmmessages:CreateDataChannel",
           "ssmmessages:OpenControlChannel",
           "ssmmessages:OpenDataChannel"
       ],
       "Resource": "*"
    },
    {
       "Sid": "KMSFullAccess",
            "Effect": "Allow",
            "Action": "kms:*",
            "Resource": "*"
    },
    {
      "Sid": "StepFullAccess",
      "Effect": "Allow",
      "Action": "states:*",
      "Resource": "*"
    },
    {
       "Sid": "LambdaFullAccess",
       "Effect": "Allow",
       "Action": [
           "cloudformation:DescribeStacks",
           "cloudformation:ListStackResources",
           "cloudwatch:ListMetrics",
           "cloudwatch:GetMetricData",
           "ec2:DescribeSecurityGroups",
           "ec2:DescribeSubnets",
           "ec2:DescribeVpcs",
           "kms:ListAliases",
           "iam:GetPolicy",
           "iam:GetPolicyVersion",
           "iam:GetRole",
           "iam:GetRolePolicy",
           "iam:ListAttachedRolePolicies",
           "iam:ListRolePolicies",
           "iam:ListRoles",
           "lambda:*",
           "logs:DescribeLogGroups",
           "states:DescribeStateMachine",
           "states:ListStateMachines",
           "tag:GetResources",
           "xray:GetTraceSummaries",
           "xray:BatchGetTraces"
       ],
       "Resource": "*"
    },
    {
       "Sid": "LambdaIAMFullAccess",
       "Effect": "Allow",
       "Action": "iam:PassRole",
       "Resource": "*",
       "Condition": {
           "StringEquals": {
               "iam:PassedToService": "lambda.amazonaws.com"
           }
       }
    },
    {
       "Sid": "LambdaLogsFullAccess",
       "Effect": "Allow",
       "Action": [
           "logs:DescribeLogStreams",
           "logs:GetLogEvents",
           "logs:FilterLogEvents"
       ],
       "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    },
    {
       "Sid": "SNSFullAccess",
       "Action": [
           "sns:*"
       ],
       "Effect": "Allow",
       "Resource": "*"
    },
    {
       "Sid": "CloudWatchEventsFullAccess",
       "Effect": "Allow",
       "Action": "events:*",
       "Resource": "*"
    },
    {
       "Sid": "IAMPassRoleForCloudWatchEvents",
       "Effect": "Allow",
       "Action": "iam:PassRole",
       "Resource": "arn:aws:iam::*:role/AWS_Events_Invoke_Targets"
    }
  ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "vault_drone_0" {
  group      = aws_iam_group.vault_drone.name
  policy_arn = aws_iam_policy.vault_drone_0.arn
}

resource "aws_iam_group_policy_attachment" "vault_drone_1" {
  group      = aws_iam_group.vault_drone.name
  policy_arn = aws_iam_policy.vault_drone_1.arn
}

resource "aws_iam_group_policy_attachment" "vault_drone_2" {
  group      = aws_iam_group.vault_drone.name
  policy_arn = aws_iam_policy.vault_drone_2.arn
}
