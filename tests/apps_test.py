# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """

            provider "aws" {
              region = "eu-west-2"
              skip_credentials_validation = true
            }

            module "apps" {
              source = "./mymodule"

              providers = {
                aws = aws
              }

              cidr_block                      = "10.1.0.0/16"
              public_subnet_cidr_block        = "10.1.0.0/24"
              ad_subnet_cidr_block            = "10.1.0.0/24"
              az                              = "eu-west-2a"
              az2                             = "eu-west-2b"
              ad_aws_ssm_document_name        = "1234"
              ad_writer_instance_profile_name = "1234"
              naming_suffix                   = "test-dq"
              namespace                       = "test"
              haproxy_private_ip              = "1.2.3.3"
              haproxy_private_ip2             = "1.2.3.4"
              s3_httpd_config_bucket          = "s3-bucket-name"
              s3_httpd_config_bucket_key      = "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
              haproxy_config_bucket           = "s3-bucket-name"
              haproxy_config_bucket_key       = "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
              account_id                      = {"test" = "235678"}

              s3_bucket_name = {
                archive_log                   = "abcd"
                archive_data                  = "abcd"
                working_data                  = "abcd"
                landing_data                  = "abcd"
                airports_archive              = "abcd"
                airports_working              = "abcd"
                airports_internal             = "abcd"
                oag_archive                   = "abcd"
                oag_internal                  = "abcd"
                oag_transform                 = "abcd"
                acl_archive                   = "abcd"
                acl_internal                  = "abcd"
                reference_data_archive        = "abcd"
                reference_data_internal       = "abcd"
                consolidated_schedule         = "abcd"
                api_archive                   = "abcd"
                api_internal                  = "abcd"
                api_record_level_scoring      = "abcd"
                gait_internal                 = "abcd"
                cross_record_scored           = "abcd"
                reporting_internal_working    = "abcd"
                mds_extract                   = "abcd"
                raw_file_index_internal       = "abcd"
                fms_working                   = "abcd"
                drt_working                   = "abcd"
                athena_log                    = "abcd"
                ops_pipeline                  = "abcd"
                nats_archive                  = "abcd"
                nats_internal                 = "abcd"
                cdlz_bitd_input               = "abcd"
                api_arrivals                  = "abcd"
                accuracy_score                = "abcd"
                api_cdlz_msk                  = "abcd"
                drt_export                    = "abcd"
                api_rls_xrs_reconciliation    = "abcd"
                dq_fs_archive                 = "abcd"
                dq_fs_internal                = "abcd"
                dq_aws_config                 = "abcd"
                dq_asn_archive                = "abcd"
                dq_asn_internal               = "abcd"
                dq_snsgb_archive              = "abcd"
                dq_snsgb_internal             = "abcd"
                dq_asn_marine_archive         = "abcd"
                dq_asn_marine_internal        = "abcd"
                dq_rm_archive                 = "abcd"
                dq_rm_internal                = "abcd"
                dq_data_generator             = "abcd"
                dq_ais_archive                = "abcd"
                dq_ais_internal               = "abcd"
                dq_gait_landing_staging       = "abcd"
                dq_pnr_archive                = "abcd"
                dq_pnr_internal               = "abcd"
                carrier_portal_docs           = "abcd"

              }

              s3_bucket_acl = {
                archive_log                   = "private"
                archive_data                  = "private"
                working_data                  = "private"
                landing_data                  = "private"
                airports_archive              = "private"
                airports_working              = "private"
                airports_internal             = "private"
                oag_archive                   = "private"
                oag_internal                  = "private"
                oag_transform                 = "private"
                acl_archive                   = "private"
                acl_internal                  = "private"
                reference_data_archive        = "private"
                reference_data_internal       = "private"
                consolidated_schedule         = "private"
                api_archive                   = "private"
                api_internal                  = "private"
                api_record_level_scoring      = "private"
                gait_internal                 = "private"
                cross_record_scored           = "private"
                reporting_internal_working    = "private"
                mds_extract                   = "private"
                raw_file_index_internal       = "private"
                fms_working                   = "private"
                drt_working                   = "private"
                athena_log                    = "private"
                ops_pipeline                  = "private"
                nats_archive                  = "private"
                nats_internal                 = "private"
                cdlz_bitd_input               = "private"
                api_arrivals                  = "private"
                accuracy_score                = "private"
                api_cdlz_msk                  = "private"
                drt_export                    = "private"
                api_rls_xrs_reconciliation    = "private"
                dq_fs_archive                 = "private"
                dq_fs_internal                = "private"
                dq_aws_config                 = "private"
                dq_asn_archive                = "private"
                dq_asn_internal               = "private"
                dq_snsgb_archive              = "private"
                dq_snsgb_internal             = "private"
                dq_asn_marine_archive         = "private"
                dq_asn_marine_internal        = "private"
                dq_rm_archive                 = "private"
                dq_rm_internal                = "private"
                dq_data_generator             = "private"
                dq_ais_archive                = "private"
                dq_ais_internal               = "private"
                dq_gait_landing_staging       = "private"
                dq_pnr_archive                = "private"
                dq_pnr_internal               = "private"
                carrier_portal_docs           = "private"
              }

              route_table_cidr_blocks     = {
                peering_cidr = "10.3.0.0/16"
                ops_cidr     = "10.2.0.0/24"
              }
              vpc_peering_connection_ids  = {
                peering_to_peering = "1234"
                peering_to_ops     = "1234"
              }
              ad_sg_cidr_ingress = [
                "1.2.0.0/16",
                "1.2.0.0/16",
                "1.2.0.0/16"
              ]
            }
        """
        self.runner = Runner(self.snippet)
        self.result = self.runner.result

    def test_apps_vpc_cidr_block(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_vpc.appsvpc", "cidr_block"), "10.1.0.0/16")

    def test_apps_public_cidr(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_subnet.public_subnet", "cidr_block"), "10.1.0.0/24")

    def test_az_public_subnet(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_subnet.public_subnet", "availability_zone"), "eu-west-2a")

    def test_name_suffix_ari(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_internet_gateway.AppsRouteToInternet", "tags"), {"Name": "igw-apps-test-dq"})

    def test_name_suffix_appsvpc(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_vpc.appsvpc", "tags"), {"Name": "vpc-apps-test-dq"})

    def test_name_suffix_public_subnet(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_subnet.public_subnet", "tags"), {"Name": "public-subnet-apps-test-dq"})

    def test_name_suffix_ad_subnet(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_subnet.ad_subnet", "tags"), {"Name": "ad-subnet-apps-test-dq"})

    def test_name_suffix_route_table(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_route_table.apps_route_table", "tags"), {"Name": "route-table-apps-test-dq"})

    def test_name_suffix_public_route(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_route_table.apps_public_route_table", "tags"), {"Name": "public-route-table-apps-test-dq"})

    def test_name_suffix_appsnatgw(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_nat_gateway.appsnatgw", "tags"), {"Name": "natgw-apps-test-dq"})

    def test_name_suffix_archive_log(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.log_archive_bucket", "tags"), {"Name": "s3-log-archive-bucket-apps-test-dq"})

    def test_name_suffix_data_archive_log(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.data_archive_bucket", "tags"), {"Name": "s3-data-archive-bucket-apps-test-dq"})

    def test_name_suffix_data_working(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.data_working_bucket", "tags"), {"Name": "s3-data-working-bucket-apps-test-dq"})

    def test_name_suffix_airports_archive(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.airports_archive_bucket", "tags"), {"Name": "s3-dq-airports-archive-apps-test-dq"})

    def test_name_suffix_airports_internal(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.airports_internal_bucket", "tags"), {"Name": "s3-dq-airports-internal-apps-test-dq"})

    def test_name_suffix_airports_working(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.airports_working_bucket", "tags"), {"Name": "s3-dq-airports-working-apps-test-dq"})

    def test_name_suffix_nats_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.nats", "name"), "iam-group-nats-apps-test-dq")

    def test_name_suffix_nats_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.nats", "name"), "iam-group-membership-nats-apps-test-dq")

    def test_name_suffix_nats_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.nats", "name"), "iam-policy-nats-apps-test-dq")

    def test_name_suffix_nats_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.nats", "name"), "iam-user-nats-apps-test-dq")

    def test_name_suffix_rds_deploy_iam_lambda_rds(self):
        self.assertEqual(self.runner.get_value("module.apps.module.rds_deploy.aws_iam_role.lambda_rds[0]", "tags"), {"Name": "iam-lambda-rds-deploy-apps-test-dq"})

    def test_name_suffix_rds_deploy_lambda_function(self):
        self.assertEqual(self.runner.get_value("module.apps.module.rds_deploy.aws_lambda_function.lambda_rds[0]", "tags"), {"Name": "lambda-rds-deploy-apps-test-dq"})

    def test_name_suffix_rds_deploy_cloudwatch_log_group(self):
        self.assertEqual(self.runner.get_value("module.apps.module.rds_deploy.aws_cloudwatch_log_group.lambda_rds[0]", "tags"), {"Name": "log-lambda-rds-deploy-apps-test-dq"})

    def test_name_suffix_oag_archive(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.oag_archive_bucket", "tags"), {"Name": "s3-dq-oag-archive-apps-test-dq"})

    def test_name_suffix_oag_internal(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.oag_internal_bucket", "tags"), {"Name": "s3-dq-oag-internal-apps-test-dq"})

    def test_name_suffix_oag_transform(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.oag_transform_bucket", "tags"), {"Name": "s3-dq-oag-transform-apps-test-dq"})

    def test_name_oag_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.oag", "name"), "iam-group-oag-apps-test-dq")

    def test_name_oag_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.oag", "name"), "iam-group-membership-oag-apps-test-dq")

    def test_name_oag_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.oag", "name"), "iam-policy-oag-apps-test-dq")

    def test_name_oag_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.oag", "name"), "iam-user-oag-apps-test-dq")

    def test_name_acl_archive_bucket(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.acl_archive_bucket", "tags"), {"Name": "s3-dq-acl-archive-apps-test-dq"})

    def test_name_acl_internal_bucket(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.acl_internal_bucket", "tags"), {"Name": "s3-dq-acl-internal-apps-test-dq"})

    def test_name_acl_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.acl", "name"), "iam-group-acl-apps-test-dq")

    def test_name_acl_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.acl", "name"), "iam-group-membership-acl-apps-test-dq")

    def test_name_acl_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.acl", "name"), "iam-policy-acl-apps-test-dq")

    def test_name_acl_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.acl", "name"), "iam-user-acl-apps-test-dq")

    def test_name_suffix_oag_input_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-oag-input-apps-test-dq"})

    def test_name_suffix_oag_input_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_iam_role.lambda_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-oag-input-apps-test-dq"})

    def test_name_suffix_oag_input_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-oag-input-apps-test-dq"})

    def test_name_suffix_oag_input_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-oag-input-apps-test-dq"})

    def test_name_suffix_oag_input_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_cloudwatch_log_group.lambda_trigger[0]", "tags"), {"Name": "log-lambda-trigger-oag-input-apps-test-dq"})

    def test_name_suffix_oag_input_pipeline_lambda_oag_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_lambda_function.lambda_oag[0]", "tags"), {"Name": "lambda-oag-input-apps-test-dq"})

    def test_name_suffix_oag_input_pipeline_log_lambda_oag(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_input_pipeline.aws_cloudwatch_log_group.lambda_oag[0]", "tags"), {"Name": "log-lambda-oag-input-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-oag-transform-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-oag-transform-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-oag-transform-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-oag-transform-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-oag-transform-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_lambda_function.lambda_athena[0]", "tags"), {"Name": "lambda-athena-oag-transform-apps-test-dq"})

    def test_name_suffix_oag_transform_pipeline_log_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.oag_transform_pipeline.aws_cloudwatch_log_group.lambda_log_group_athena[0]", "tags"), {"Name": "lambda-log-group-athena-oag-transform-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-acl-input-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-acl-input-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-acl-input-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-acl-input-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-acl-input-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-acl-input-apps-test-dq"})

    def test_name_suffix_acl_input_pipeline_log_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.acl_input_pipeline.aws_cloudwatch_log_group.lambda_log_group_athena[0]", "tags"), {"Name": "lambda-log-group-athena-acl-input-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-reference-data-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-reference-data-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-reference-data-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-reference-data-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-reference-data-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_lambda_function.lambda_athena[0]", "tags"), {"Name": "lambda-athena-reference-data-apps-test-dq"})

    def test_name_suffix_reference_data_pipeline_log_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.reference_data_pipeline.aws_cloudwatch_log_group.lambda_log_group_athena[0]", "tags"), {"Name": "lambda-log-group-athena-reference-data-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_consolidated_schedule_pipeline_log_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.consolidated_schedule_pipeline.aws_cloudwatch_log_group.lambda_log_group_athena[0]", "tags"), {"Name": "lambda-log-group-athena-consolidated-schedule-apps-test-dq"})

    def test_name_suffix_cdlz_iam_lambda(self):
        self.assertEqual(self.runner.get_value("module.apps.module.cdlz.aws_iam_role.lambda_acquire", "tags"), {"Name": "iam-lambda-cdlz-apps-test-dq"})

    def test_name_suffix_cdlz_ssm_lambda(self):
        self.assertEqual(
            self.runner.get_value("module.apps.module.cdlz.aws_ssm_parameter.lambda_enabled[0]", "tags"), {"Name": "ssm-lambda-enabled-cdlz-apps-test-dq"})

    def test_name_suffix_cdlz_lambda(self):
        self.assertEqual(self.runner.get_value("module.apps.module.cdlz.aws_lambda_function.lambda_acquire[0]", "tags"), {"Name": "lambda-cdlz-apps-test-dq"})

    def test_name_suffix_cdlz_log_lambda(self):
        self.assertEqual(
            self.runner.get_value("module.apps.module.cdlz.aws_cloudwatch_log_group.lambda_acquire[0]", "tags"), {"Name": "log-lambda-cdlz-apps-test-dq"})

    def test_name_suffix_api_input_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_input_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-api-input-apps-test-dq"})

    def test_name_suffix_api_input_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_input_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-api-input-apps-test-dq"})

    def test_name_suffix_api_input_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_input_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-api-input-apps-test-dq"})

    def test_name_suffix_api_input_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_input_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-api-input-apps-test-dq"})

    def test_name_suffix_api_input_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_input_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-api-input-apps-test-dq"})

    def test_name_suffix_api_input_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_input_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-api-input-apps-test-dq"})

    def test_name_suffix_api_record_level_score_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_record_level_score_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-api-record-level-score-apps-test-dq"})

    def test_name_suffix_api_record_level_score_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_record_level_score_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-api-record-level-score-apps-test-dq"})

    def test_name_suffix_api_record_level_score_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_record_level_score_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-api-record-level-score-apps-test-dq"})

    def test_name_suffix_api_record_level_score_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_record_level_score_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-api-record-level-score-apps-test-dq"})

    def test_name_suffix_api_record_level_score_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_record_level_score_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-api-record-level-score-apps-test-dq"})

    def test_name_suffix_api_record_level_score_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_record_level_score_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-api-record-level-score-apps-test-dq"})

    def test_name_suffix_gait_pipeline_step_function_exec(self):
        self.assertEqual(self.runner.get_value("module.apps.module.gait_pipeline.aws_iam_role.step_function_exec[0]", "tags"), {"Name": "step-function-exec-gait-apps-test-dq"})

    def test_name_suffix_gait_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.gait_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-gait-apps-test-dq"})

    def test_name_suffix_gait_pipeline_lambda_gait(self):
        self.assertEqual(self.runner.get_value("module.apps.module.gait_pipeline.aws_lambda_function.lambda_gait[0]", "tags"), {"Name": "lambda-gait-apps-test-dq"})

    def test_name_suffix_gait_pipeline_log_lambda_gait(self):
        self.assertEqual(self.runner.get_value("module.apps.module.gait_pipeline.aws_cloudwatch_log_group.lambda_log_group_gait[0]", "tags"), {"Name": "lambda-log-group-gait-apps-test-dq"})

    def test_name_suffix_fms_postgres(self):
        self.assertEqual(self.runner.get_value("module.apps.module.fms.aws_db_instance.postgres", "tags"), {"Name": "postgres-fms-apps-test-dq"})

    def test_name_suffix_cross_record_scored_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_cross_record_scored_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-api-cross-record-scored-apps-test-dq"})

    def test_name_suffix_cross_record_scored_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_cross_record_scored_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-api-cross-record-scored-apps-test-dq"})

    def test_name_suffix_cross_record_scored_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_cross_record_scored_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-api-cross-record-scored-apps-test-dq"})

    def test_name_suffix_cross_record_scored_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_cross_record_scored_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-api-cross-record-scored-apps-test-dq"})

    def test_name_suffix_cross_record_scored_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_cross_record_scored_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-api-cross-record-scored-apps-test-dq"})

    def test_name_suffix_cross_record_scored_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.api_cross_record_scored_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-api-cross-record-scored-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_iam_role.lambda_role_trigger[0]", "tags"), {"Name": "iam-lambda-trigger-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_ssm_parameter.lambda_trigger_enabled[0]", "tags"), {"Name": "ssm-lambda-trigger-enabled-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_sfn_state_machine(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_sfn_state_machine.sfn_state_machine[0]", "tags"), {"Name": "sfn-state-machine-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_lambda_function.lambda_trigger[0]", "tags"), {"Name": "lambda-trigger-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_cloudwatch_log_group.lambda_log_group_trigger[0]", "tags"), {"Name": "lambda-log-group-trigger-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_lambda_function.lambda_athena[0]", "tags"), {"Name": "lambda-athena-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_log_lambda_athena(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_cloudwatch_log_group.lambda_log_group_athena[0]", "tags"), {"Name": "lambda-log-group-athena-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_iam_lambda_rds(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_iam_role.lambda_rds[0]", "tags"), {"Name": "iam-lambda-rds-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_lambda_rds(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_lambda_function.lambda_rds[0]", "tags"), {"Name": "lambda-rds-internal-reporting-apps-test-dq"})

    def test_name_suffix_internal_reporting_pipeline_log_lambda_rds(self):
        self.assertEqual(self.runner.get_value("module.apps.module.internal_reporting_pipeline.aws_cloudwatch_log_group.lambda_rds[0]", "tags"), {"Name": "log-lambda-rds-internal-reporting-apps-test-dq"})

    def test_name_suffix_dq_pipeline_ops_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.dq_pipeline_ops_group", "name"), "dq-pipeline-ops-test")

    def test_name_suffix_dq_pipeline_ops_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.dq_pipeline_ops_policy", "name"), "dq-pipeline-ops-policy-test")

    # def test_name_suffix_mds_extractor_lambda_mds_extractor(self):
    #     self.assertEqual(self.runner.get_value("module.apps.module.mds_extractor.aws_lambda_function.lambda_mds_extractor[0]", "tags"), {"Name": "lambda-mds-extractor-apps-test-dq"})

    # def test_name_suffix_mds_extractor_lambda_role_mds_extractor(self):
    #     self.assertEqual(self.runner.get_value("module.apps.module.mds_extractor.aws_iam_role.lambda_role_mds_extractor[0]", "tags"), {"Name": "lambda-role-mds-extractor-apps-test-dq"})

    # def test_name_suffix_mds_extractor_lambda_log_group_mds_extractor(self):
    #     self.assertEqual(self.runner.get_value("module.apps.module.mds_extractor.aws_cloudwatch_log_group.lambda_log_group_mds_extractor[0]", "tags"), {"Name": "lambda-log-group-mds-extractor-apps-test-dq"})

    def test_name_suffix_athena_log(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.athena_log_bucket", "tags"), {"Name": "s3-dq-athena-log-apps-test-dq"})

    def test_name_suffix_ops_pipeline_iam_lambda_reconcile(self):
        self.assertEqual(self.runner.get_value("module.apps.module.ops_pipeline.aws_lambda_function.lambda_reconcile[0]", "tags"), {"Name": "lambda-reconcile-ops-apps-test-dq"})

    def test_name_suffix_ops_pipeline_iam_lambda_role_reconcile(self):
        self.assertEqual(self.runner.get_value("module.apps.module.ops_pipeline.aws_iam_role.lambda_role_reconcile[0]", "tags"), {"Name": "lambda-role-reconcile-ops-apps-test-dq"})

    def test_name_suffix_ops_pipeline_lambda_log_group_reconcile(self):
        self.assertEqual(self.runner.get_value("module.apps.module.ops_pipeline.aws_cloudwatch_log_group.lambda_log_group_reconcile[0]", "tags"), {"Name": "lambda-log-group-reconcile-ops-apps-test-dq"})

    def test_name_suffix_ops_pipeline_iam_lambda_cleaner(self):
        self.assertEqual(self.runner.get_value("module.apps.module.ops_pipeline.aws_lambda_function.lambda_cleaner[0]", "tags"), {"Name": "lambda-cleaner-ops-apps-test-dq"})

    def test_name_suffix_ops_pipeline_iam_lambda_role_cleaner(self):
        self.assertEqual(self.runner.get_value("module.apps.module.ops_pipeline.aws_iam_role.lambda_role_cleaner[0]", "tags"), {"Name": "lambda-role-cleaner-ops-apps-test-dq"})

    def test_name_suffix_ops_pipeline_lambda_log_group_cleaner(self):
        self.assertEqual(self.runner.get_value("module.apps.module.ops_pipeline.aws_cloudwatch_log_group.lambda_log_group_cleaner[0]", "tags"), {"Name": "lambda-log-group-cleaner-ops-apps-test-dq"})

    def test_name_crt_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.crt", "name"), "iam-group-crt-apps-test-dq")

    def test_name_crt_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.crt", "name"), "iam-group-membership-crt-apps-test-dq")

    def test_name_crt_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.crt", "name"), "iam-policy-crt-apps-test-dq")

    def test_name_crt_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.crt", "name"), "iam-user-crt-apps-test-dq")

    def test_name_athena_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.athena", "name"), "iam-group-athena-apps-test-dq")

    def test_name_athena_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.athena", "name"), "iam-group-membership-athena-apps-test-dq")

    def test_name_athena_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.athena", "name"), "iam-policy-athena-apps-test-dq")

    def test_name_athena_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.athena", "name"), "iam-user-athena-apps-test-dq")

    def test_name_ssm_athena_id(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.athena_id", "name"), "kubernetes-athena-user-id-app-apps-test-dq")

    def test_name_ssm_athena_key(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.athena_key", "name"), "kubernetes-athena-user-key-app-apps-test-dq")

    def test_name_nats_history_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.nats_history", "name"), "iam-group-nats-history-apps-test-dq")

    def test_name_nats_historyiam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.nats_history", "name"), "iam-group-membership-nats-history-apps-test-dq")

    def test_name_nats_history_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.nats_history", "name"), "iam-policy-nats-history-apps-test-dq")

    def test_name_nats_history_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.nats_history", "name"), "iam-user-nats-history-apps-test-dq")

    def test_name_ssm_nats_history_id(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.nats_history_id", "name"), "nats-history-user-id-apps-test-dq")

    def test_name_ssm_nats_history_key(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.nats_history_key", "name"), "nats-history-user-key-apps-test-dq")

    def test_name_rds_maintenance_history_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.rds_maintenance", "name"), "iam-group-rds-maintenance-apps-test-dq")

    def test_name_rds_maintenance_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.rds_maintenance", "name"), "iam-group-membership-rds-maintenance-apps-test-dq")

    def test_name_rds_maintenance_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.lambda_policy_rds_maintenance", "name"), "iam-policy-rds-maintenance-apps-test-dq")

    def test_name_rds_maintenance_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.rds_maintenance", "name"), "iam-user-rds-maintenance-apps-test-dq")

    def test_name_ssm_rds_maintenance_id(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.rds_maintenance_id", "name"), "kubernetes-rds-maintenance-user-id-apps-test-dq")

    def test_name_ssm_rds_maintenance_key(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.rds_maintenance_key", "name"), "kubernetes-rds-maintenance-user-key-apps-test-dq")

    def test_name_athena_maintenance_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.athena_maintenance", "name"), "iam-group-athena-maintenance-apps-test-dq")

    def test_name_athena_maintenance_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.athena_maintenance", "name"), "iam-group-membership-athena-maintenance-apps-test-dq")

    def test_name_athena_maintenance_glue_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.athena_maintenance_glue", "name"), "iam-policy-athena-maintenance-glue-apps-test-dq")

    def test_name_athena_maintenance_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.athena_maintenance", "name"), "iam-user-athena-maintenance-apps-test-dq")

    def test_name_jira_backup_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.data_archive_bucket", "name"), "data_archive_bucket")

    def test_name_jira_backup_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.data_archive_bucket", "name"), "data_archive_bucket_user")

    def test_name_ssm_jirs_backup_id(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.jira_id", "name"), "kubernetes-jira-backup-user-id-apps-test-dq")

    def test_name_ssm_jira_backup_key(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_ssm_parameter.jira_key", "name"), "kubernetes-jira-backup-user-key-apps-test-dq")

    def test_name_suffix_cdlz_bitd_input(self):
          self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.cdlz_bitd_input", "tags"), {"Name": "s3-dq-cdlz-bitd-input-apps-test-dq"})

    def test_name_suffix_api_arrivals(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.api_arrivals_bucket", "tags"), {"Name": "s3-dq-api-arrivals-apps-test-dq"})

    def test_name_suffix_accuracy_score(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.accuracy_score_bucket", "tags"), {"Name": "s3-dq-accuracy-score-apps-test-dq"})

    def test_name_suffix_api_cdlz_msk(self):
         self.assertEqual(self.runner.get_value("module.apps.aws_s3_bucket.api_cdlz_msk_bucket", "tags"), {'Name': "s3-dq-api-cdlz-msk-apps-test-dq"})

    def test_api_cdlz_msk_bucket_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.api_cdlz_msk_bucket", "name"), "api_cdlz_msk_bucket")

    def test_api_cdlz_msk_bucket_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.api_cdlz_msk_bucket", "name"), "api_cdlz_msk_bucket_user")

    def test_name_athena_tableau_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.athena_tableau", "name"), "iam-group-athena-tableau-apps-test-dq")

    def test_name_athena_tableau_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.athena_tableau", "name"), "iam-group-membership-athena-tableau-apps-test-dq")

    def test_name_athena_tableau_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.athena_tableau", "name"), "iam-policy-athena-tableau-apps-test-dq")

    def test_name_athena_tableau_glue_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.athena_tableau_glue", "name"), "iam-policy-athena-tableau-glue-apps-test-dq")

    def test_name_athena_tableau_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.athena_tableau", "name"), "iam-user-athena-tableau-apps-test-dq")

    def test_name_vault_admin_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.vault_admin", "name"), "iam-group-vault-admin")

    def test_name_vault_admin_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.vault_admin", "name"), "iam-group-membership-vault-admin")

    def test_name_vault_admin_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.vault_admin", "name"), "iam-policy-vault-admin")

    def test_name_vault_admin_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.vault_admin", "name"), "iam-user-vault-admin")

    def test_name_vault_drone_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.vault_drone", "name"), "iam-group-vault-drone")

    def test_name_cloud_watch_log_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.cloud_watch_log_policy", "name"), "iam-policy-cloud-watch-apps-test-dq")

    def test_name_data_archive_bucket_iam_policy(self):
       self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.data_archive_bucket", "name"), "iam-policy-data-archive-bucket-apps-test-dq")

    def test_name_suffix_monitor_iam_group(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group.monitor", "name"), "iam-group-monitor-apps-test-dq")

    def test_name_suffix_monitor_iam_group_membership(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_group_membership.monitor", "name"), "iam-group-membership-monitor-apps-test-dq")

    def test_name_suffix_monitor_glue_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.monitor_glue", "name"), "iam-policy-monitor-glue-apps-test-dq")

    def test_name_suffix_monitor_ssm_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.monitor_ssm", "name"), "iam-policy-monitor-ssm-apps-test-dq")

    def test_name_suffix_monitor_athena_iam_policy(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_policy.monitor_athena", "name"), "iam-policy-monitor-athena-apps-test-dq")

    def test_name_suffix_monitor_iam_user(self):
        self.assertEqual(self.runner.get_value("module.apps.aws_iam_user.monitor", "name"), "iam-user-monitor-apps-test-dq")


if __name__ == '__main__':
    unittest.main()
