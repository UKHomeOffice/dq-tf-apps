module "data_feeds" {
  source = "github.com/UKHomeOffice/dq-tf-datafeeds?ref=initial-df"

  providers = {
    aws = "aws.APPS"
  }

  appsvpc_id            = "12345"
  appsvpc_cidr_block    = "10.1.0.0/16"
  opsvpc_cidr_block     = "10.2.0.0/16"
  data_feeds_cidr_block = "10.1.4.0/24"
  az                    = "eu-west-2a"
  name_prefix           = "dq-"
}
