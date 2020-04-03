provider "aws" {}

locals {
  naming_suffix = "apps-${var.naming_suffix}"
}

module "external_tableau" {
  source                       = "github.com/UKHomeOffice/dq-tf-external-tableau"
  acp_prod_ingress_cidr        = "10.5.0.0/16"
  dq_ops_ingress_cidr          = "${var.route_table_cidr_blocks["ops_cidr"]}"
  dq_external_dashboard_subnet = "10.1.14.0/24"
  peering_cidr_block           = "10.3.0.0/16"
  apps_vpc_id                  = "${aws_vpc.appsvpc.id}"
  route_table_id               = "${aws_route_table.apps_route_table.id}"
  az                           = "${var.az}"
  naming_suffix                = "${local.naming_suffix}"
  s3_archive_bucket_name       = "${aws_s3_bucket.data_archive_bucket.id}"
  s3_archive_bucket            = "${aws_s3_bucket.data_archive_bucket.arn}"
  s3_archive_bucket_key        = "${aws_kms_key.bucket_key.arn}"
  haproxy_private_ip2          = "${var.haproxy_private_ip2}"
  environment                  = "${var.namespace}"
  haproxy_config_bucket        = "${var.haproxy_config_bucket}"
  haproxy_config_bucket_key    = "${var.haproxy_config_bucket_key}"
  rds_enhanced_monitoring_role = "${aws_iam_role.rds_enhanced_monitoring_role.arn}"
}

module "internal_tableau" {
  source                                = "github.com/UKHomeOffice/dq-tf-internal-tableau"
  acp_prod_ingress_cidr                 = "10.5.0.0/16"
  dq_ops_ingress_cidr                   = "${var.route_table_cidr_blocks["ops_cidr"]}"
  dq_internal_dashboard_subnet_cidr     = "10.1.12.0/24"
  dq_internal_dashboard_subnet_cidr_az2 = "10.1.13.0/24"
  peering_cidr_block                    = "10.3.0.0/16"
  apps_vpc_id                           = "${aws_vpc.appsvpc.id}"
  route_table_id                        = "${aws_route_table.apps_route_table.id}"
  az                                    = "${var.az}"
  az2                                   = "${var.az2}"
  naming_suffix                         = "${local.naming_suffix}"
  s3_archive_bucket_name                = "${aws_s3_bucket.data_archive_bucket.id}"
  s3_archive_bucket                     = "${aws_s3_bucket.data_archive_bucket.arn}"
  s3_archive_bucket_key                 = "${aws_kms_key.bucket_key.arn}"
  haproxy_private_ip                    = "${var.haproxy_private_ip}"
  environment                           = "${var.namespace}"
  s3_httpd_config_bucket                = "${var.s3_httpd_config_bucket}"
  s3_httpd_config_bucket_key            = "${var.s3_httpd_config_bucket_key}"
  security_group_ids                    = "${module.lambda.lambda_sgrp}"
  lambda_subnet                         = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2                     = "${module.lambda.lambda_subnet_az2}"
  rds_enhanced_monitoring_role          = "${aws_iam_role.rds_enhanced_monitoring_role.arn}"
}

module "data_feeds" {
  source                       = "github.com/ukhomeoffice/dq-tf-datafeeds"
  appsvpc_id                   = "${aws_vpc.appsvpc.id}"
  opssubnet_cidr_block         = "${var.route_table_cidr_blocks["ops_cidr"]}"
  data_feeds_cidr_block        = "10.1.4.0/24"
  data_feeds_cidr_block_az2    = "10.1.5.0/24"
  peering_cidr_block           = "10.3.0.0/16"
  az                           = "${var.az}"
  az2                          = "${var.az2}"
  lambda_subnet                = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2            = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp                  = "${module.lambda.lambda_sgrp}"
  naming_suffix                = "${local.naming_suffix}"
  route_table_id               = "${aws_route_table.apps_route_table.id}"
  rds_enhanced_monitoring_role = "${aws_iam_role.rds_enhanced_monitoring_role.arn}"
  environment                  = "${var.namespace}"
}

module "data_ingest" {
  source                       = "github.com/ukhomeoffice/dq-tf-dataingest"
  appsvpc_id                   = "${aws_vpc.appsvpc.id}"
  opssubnet_cidr_block         = "${var.route_table_cidr_blocks["ops_cidr"]}"
  data_ingest_cidr_block       = "10.1.6.0/24"
  data_ingest_rds_cidr_block   = "10.1.7.0/24"
  peering_cidr_block           = "10.3.0.0/16"
  az                           = "${var.az}"
  az2                          = "${var.az2}"
  naming_suffix                = "${local.naming_suffix}"
  route_table_id               = "${aws_route_table.apps_route_table.id}"
  logging_bucket_id            = "${aws_s3_bucket.log_archive_bucket.id}"
  archive_bucket               = "${aws_s3_bucket.data_archive_bucket.arn}"
  archive_bucket_name          = "${aws_s3_bucket.data_archive_bucket.id}"
  apps_buckets_kms_key         = "${aws_kms_key.bucket_key.arn}"
  environment                  = "${var.namespace}"
  rds_enhanced_monitoring_role = "${aws_iam_role.rds_enhanced_monitoring_role.arn}"
}

module "lambda" {
  source                    = "github.com/ukhomeoffice/dq-tf-lambda"
  appsvpc_id                = "${aws_vpc.appsvpc.id}"
  dq_lambda_subnet_cidr     = "10.1.42.0/24"
  dq_lambda_subnet_cidr_az2 = "10.1.43.0/24"
  az                        = "${var.az}"
  az2                       = "${var.az2}"
  naming_suffix             = "${local.naming_suffix}"
  route_table_id            = "${aws_route_table.apps_route_table.id}"
}

module "airports_pipeline" {
  source            = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-airports-pipeline.git"
  kms_key_s3        = "${aws_kms_key.bucket_key.arn}"
  kms_key_glue      = "${data.aws_kms_key.glue.arn}"
  lambda_subnet     = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2 = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp       = "${module.lambda.lambda_sgrp}"
  rds_db_name       = "${var.rds_db_name}"
  rds_address       = "${module.internal_tableau.rds_internal_tableau_address}"
  lambda_slack      = "${module.ops_pipeline.lambda_slack}"
  naming_suffix     = "${local.naming_suffix}"
  namespace         = "${var.namespace}"
}

module "airports_input_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-airports-input.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  kms_key_glue  = "${data.aws_kms_key.glue.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "oag_input_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-oag-input-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "oag_transform_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-oag-transform-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  naming_suffix = "${local.naming_suffix}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  namespace     = "${var.namespace}"
}

module "acl_input_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-acl-input-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  naming_suffix = "${local.naming_suffix}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  namespace     = "${var.namespace}"
}

module "reference_data_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-reference-data-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "consolidated_schedule_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-consolidated-schedule-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "cdlz" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-cdlz.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "api_input_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-api-input-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "api_record_level_score_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-api-record-level-score-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "api_cross_record_scored_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-api-cross-record-score-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "gait_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-gait-pipeline.git"
  kms_key_s3    = "${aws_kms_key.bucket_key.arn}"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "internal_reporting_pipeline" {
  source                       = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-internal-reporting-pipeline.git"
  lambda_subnet                = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2            = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp                  = "${module.lambda.lambda_sgrp}"
  rds_db_name                  = "${var.rds_db_name}"
  rds_internal_tableau_address = "${module.internal_tableau.rds_internal_tableau_address}"
  kms_key_s3                   = "${aws_kms_key.bucket_key.arn}"
  lambda_slack                 = "${module.ops_pipeline.lambda_slack}"
  naming_suffix                = "${local.naming_suffix}"
  namespace                    = "${var.namespace}"
}

module "rds_deploy" {
  source                               = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-rds-deploy.git"
  lambda_subnet                        = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2                    = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp                          = "${module.lambda.lambda_sgrp}"
  rds_internal_tableau_address         = "${module.internal_tableau.rds_internal_tableau_address}"
  rds_fms_address                      = "${module.fms.rds_address}"
  rds_datafeed_address                 = "${module.data_feeds.rds_address}"
  naming_suffix                        = "${local.naming_suffix}"
  namespace                            = "${var.naming_suffix}"
  rds_internal_tableau_staging_address = "${module.internal_tableau.rds_internal_tableau_staging_endpoint}"
}

module "fms_pipeline" {
  source            = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-fms-pipeline.git"
  lambda_subnet     = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2 = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp       = "${module.lambda.lambda_sgrp}"
  rds_address       = "${module.fms.rds_address}"
  kms_key_s3        = "${aws_kms_key.bucket_key.arn}"
  lambda_slack      = "${module.ops_pipeline.lambda_slack}"
  naming_suffix     = "${local.naming_suffix}"
  namespace         = "${var.namespace}"
}

module "drt_pipeline" {
  source            = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-drt-pipeline.git"
  lambda_subnet     = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2 = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp       = "${module.lambda.lambda_sgrp}"
  rds_address       = "${module.data_feeds.rds_address}"
  kms_key_s3        = "${aws_kms_key.bucket_key.arn}"
  lambda_slack      = "${module.ops_pipeline.lambda_slack}"
  naming_suffix     = "${local.naming_suffix}"
  namespace         = "${var.namespace}"
}

module "carrier_portal_pipeline" {
  source            = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-carrier-portal-pipeline.git"
  lambda_subnet     = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2 = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp       = "${module.lambda.lambda_sgrp}"
  rds_address       = "${module.external_tableau.rds_address}"
  kms_key_s3        = "${aws_kms_key.bucket_key.arn}"
  lambda_slack      = "${module.ops_pipeline.lambda_slack}"
  naming_suffix     = "${local.naming_suffix}"
  namespace         = "${var.namespace}"
}

module "mds_extractor" {
  source            = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-mds-extractor.git"
  lambda_subnet     = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2 = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp       = "${module.lambda.lambda_sgrp}"
  server            = "${module.data_ingest.rds_mds_address}"
  kms_key_s3        = "${aws_kms_key.bucket_key.arn}"
  naming_suffix     = "${local.naming_suffix}"
  namespace         = "${var.namespace}"
}

module "raw_file_index" {
  source            = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-raw-file-index.git"
  kms_key_s3        = "${aws_kms_key.bucket_key.arn}"
  lambda_subnet     = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2 = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp       = "${module.lambda.lambda_sgrp}"
  rds_db_name       = "${var.rds_db_name}"
  rds_address       = "${module.internal_tableau.rds_internal_tableau_address}"
  lambda_slack      = "${module.ops_pipeline.lambda_slack}"
  naming_suffix     = "${local.naming_suffix}"
  namespace         = "${var.namespace}"
}

module "fms" {
  source     = "github.com/ukhomeoffice/dq-tf-fms"
  appsvpc_id = "${aws_vpc.appsvpc.id}"

  opssubnet_cidr_block = "${var.route_table_cidr_blocks["ops_cidr"]}"
  fms_cidr_block       = "10.1.40.0/24"
  fms_cidr_block_az2   = "10.1.41.0/24"
  peering_cidr_block   = "10.3.0.0/16"

  az                           = "${var.az}"
  az2                          = "${var.az2}"
  naming_suffix                = "${local.naming_suffix}"
  route_table_id               = "${aws_route_table.apps_route_table.id}"
  rds_enhanced_monitoring_role = "${aws_iam_role.rds_enhanced_monitoring_role.arn}"
  environment                  = "${var.namespace}"
}

module "ops_pipeline" {
  source                                = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-pipeline-ops.git"
  kms_key_s3                            = "${aws_kms_key.bucket_key.arn}"
  lambda_subnet                         = "${module.lambda.lambda_subnet}"
  lambda_subnet_az2                     = "${module.lambda.lambda_subnet_az2}"
  lambda_sgrp                           = "${module.lambda.lambda_sgrp}"
  rds_internal_tableau_address          = "${module.internal_tableau.rds_internal_tableau_address}"
  rds_fms_address                       = "${module.fms.rds_address}"
  rds_datafeed_address                  = "${module.data_feeds.rds_address}"
  naming_suffix                         = "${local.naming_suffix}"
  namespace                             = "${var.namespace}"
  athena_maintenance_bucket             = "${var.athena_maintenance_bucket}"
  dq_pipeline_ops_readwrite_bucket_list = "${var.dq_pipeline_ops_readwrite_bucket_list}"
}

module "dailytasks" {
  source        = "github.com/UKHomeOffice/dq-tf-dailytasks"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "nats_internal_pipeline" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-fpl-pipeline.git"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "cdlz_bitd_input" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-btid-cdlz-pipeline.git"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

module "kpi_accuracy_scoring" {
  source        = "git::ssh://git@gitlab.digital.homeoffice.gov.uk:2222/dacc-dq/dq-tf-kpi-accuracy-scoring-pipeline.git"
  lambda_slack  = "${module.ops_pipeline.lambda_slack}"
  naming_suffix = "${local.naming_suffix}"
  namespace     = "${var.namespace}"
}

resource "aws_vpc" "appsvpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags {
    Name = "vpc-${local.naming_suffix}"
  }
}

resource "aws_route_table" "apps_route_table" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  tags {
    Name = "route-table-${local.naming_suffix}"
  }
}

resource "aws_route" "ops" {
  route_table_id            = "${aws_route_table.apps_route_table.id}"
  destination_cidr_block    = "${var.route_table_cidr_blocks["ops_cidr"]}"
  vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_to_ops"]}"
}

resource "aws_route" "peering" {
  route_table_id            = "${aws_route_table.apps_route_table.id}"
  destination_cidr_block    = "${var.route_table_cidr_blocks["peering_cidr"]}"
  vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_to_peering"]}"
}

resource "aws_route" "nat" {
  route_table_id         = "${aws_route_table.apps_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.appsnatgw.id}"
}

resource "aws_route_table" "apps_public_route_table" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  tags {
    Name = "public-route-table-${local.naming_suffix}"
  }
}

resource "aws_route" "igw" {
  route_table_id         = "${aws_route_table.apps_public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.AppsRouteToInternet.id}"
}

resource "aws_eip" "appseip" {
  vpc = true
}

resource "aws_nat_gateway" "appsnatgw" {
  allocation_id = "${aws_eip.appseip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"

  tags {
    Name = "natgw-${local.naming_suffix}"
  }
}

resource "aws_internet_gateway" "AppsRouteToInternet" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  tags {
    Name = "igw-${local.naming_suffix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.public_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "public-subnet-${local.naming_suffix}"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.apps_public_route_table.id}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
