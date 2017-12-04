module "data_ingest" {
  source = "github.com/UKHomeOffice/dq-tf-dataingest?ref=initial-di"

  providers = {
    aws = "aws.APPS"
  }

  appsvpc_id             = "12345"
  appsvpc_cidr_block     = "10.1.0.0/16"
  opsvpc_cidr_block      = "10.2.0.0/16"
  data_ingest_cidr_block = "10.1.6.0/24"
  az                     = "eu-west-2a"
  name_prefix            = "dq-"
}

module "di_connectivity_tester_db" {
  source    = "github.com/ukhomeoffice/connectivity-tester-tf"
  user_data = "CHECK_self=127.0.0.1:80 CHECK_google=google.com:80 CHECK_googletls=google.com:443 LISTEN_tcp=0.0.0.0:5432"

  providers = {
    aws = "aws.APPS"
  }

  security_groups = ["${module.data_ingest.di_db_sg}"]
  subnet_id       = "${module.data_ingest.di_subnet_id}"
}

module "di_connectivity_tester_web" {
  source    = "github.com/ukhomeoffice/connectivity-tester-tf"
  user_data = "CHECK_self=127.0.0.1:80 CHECK_google=google.com:80 CHECK_googletls=google.com:443 LISTEN_rdp=0.0.0.0:3389 LISTEN_tcp=0.0.0.0:135"

  providers = {
    aws = "aws.APPS"
  }

  security_groups = ["${module.data_ingest.di_web_sg}"]
  subnet_id       = "${module.data_ingest.di_subnet_id}"
}
