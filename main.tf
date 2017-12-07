provider "aws" {}

module "external_tableau" {
  source = "github.com/UKHomeOffice/dq-tf-external-tableau"

  acp_prod_ingress_cidr        = "10.5.0.0/16"
  dq_ops_ingress_cidr          = "10.2.0.0/16"
  dq_external_dashboard_subnet = "10.1.14.0/24"
  greenplum_ip                 = "${module.gpdb.gpdb_master1_ip}"
  apps_vpc_id                  = "${aws_vpc.appsvpc.id}"
  route_table_id               = "${aws_route_table.apps_route_table.id}"
}

module "internal_tableau" {
  source                            = "github.com/UKHomeOffice/dq-tf-internal-tableau"
  acp_prod_ingress_cidr             = "10.5.0.0/16"
  dq_ops_ingress_cidr               = "10.2.0.0/16"
  dq_internal_dashboard_subnet_cidr = "10.1.12.0/24"
  greenplum_ip                      = "${module.gpdb.gpdb_master1_ip}"
  apps_vpc_id                       = "${aws_vpc.appsvpc.id}"
  route_table_id                    = "${aws_route_table.apps_route_table.id}"
}

module "bdm" {
  source                = "github.com/ukhomeoffice/dq-tf-business-data-manager"
  dq_data_pipeline_cidr = "10.1.8.0/24"
  dq_opps_subnet_1_cidr = "10.2.0.0/24"
  dq_BDM_subnet_cidr    = "10.1.10.0/24"
  apps_vpc_id           = "${aws_vpc.appsvpc.id}"
  route_table_id        = "${aws_route_table.apps_route_table.id}"
}

module "data_feeds" {
  source                    = "github.com/ukhomeoffice/dq-tf-datafeeds"
  appsvpc_id                = "${aws_vpc.appsvpc.id}"
  data_pipe_apps_cidr_block = "10.1.8.0/24"
  opssubnet_cidr_block      = "10.2.0.0/24"
  data_feeds_cidr_block     = "10.1.4.0/24"
  az                        = "${var.az}"
  name_prefix               = "${local.name_prefix}"
  route_table_id            = "${aws_route_table.apps_route_table.id}"
}

module "data_ingest" {
  source                    = "github.com/ukhomeoffice/dq-tf-dataingest"
  appsvpc_id                = "${aws_vpc.appsvpc.id}"
  data_pipe_apps_cidr_block = "10.8.0.0/24"
  opssubnet_cidr_block      = "10.2.0.0/24"
  data_ingest_cidr_block    = "10.1.6.0/24"
  az                        = "${var.az}"
  name_prefix               = "${local.name_prefix}"
  route_table_id            = "${aws_route_table.apps_route_table.id}"
}

module "data_pipeline" {
  source                    = "github.com/UKHomeOffice/dq-tf-datapipeline"
  appsvpc_id                = "${aws_vpc.appsvpc.id}"
  appsvpc_cidr_block        = "${var.cidr_block}"
  opssubnet_cidr_block      = "10.2.0.0/24"
  data_pipe_apps_cidr_block = "10.1.8.0/24"
  az                        = "${var.az}"
  name_prefix               = "${local.name_prefix}"
  route_table_id            = "${aws_route_table.apps_route_table.id}"
}

module "gpdb" {
  source                        = "github.com/UKHomeOffice/dq-tf-gpdb"
  appsvpc_id                    = "${aws_vpc.appsvpc.id}"
  dq_database_cidr_block        = "10.1.2.0/24"
  internal_dashboard_cidr_block = "10.1.12.0/24"
  external_dashboard_cidr_block = "10.1.14.0/24"
  data_ingest_cidr_block        = "10.1.6.0/24"
  data_pipe_apps_cidr_block     = "10.1.8.0/24"
  data_feeds_cidr_block         = "10.1.4.0/24"
  opssubnet_cidr_block          = "10.2.0.0/24"
  az                            = "${var.az}"
  name_prefix                   = "${local.name_prefix}"
  route_table_id                = "${aws_route_table.apps_route_table.id}"
}

locals {
  name_prefix = "${var.name_prefix}apps-"
}

resource "aws_vpc" "appsvpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${local.name_prefix}vpc"
  }
}

resource "aws_route_table" "apps_route_table" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.appsnatgw.id}"
  }

  tags {
    Name = "${local.name_prefix}route-table"
  }
}

resource "aws_route_table" "apps_public_route_table" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.AppsRouteToInternet.id}"
  }

  tags {
    Name = "${local.name_prefix}public-route-table"
  }
}

resource "aws_eip" "appseip" {
  vpc = true
}

resource "aws_nat_gateway" "appsnatgw" {
  allocation_id = "${aws_eip.appseip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"

  tags {
    Name = "${local.name_prefix}natgw"
  }
}

resource "aws_internet_gateway" "AppsRouteToInternet" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  tags {
    Name = "${local.name_prefix}igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.public_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}public-subnet"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.apps_public_route_table.id}"
}
