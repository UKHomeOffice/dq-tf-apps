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
              skip_get_ec2_platforms = true
            }

            module "apps" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }

              cidr_block                      = "10.1.0.0/16"
              public_subnet_cidr_block        = "10.1.0.0/24"
              ad_subnet_cidr_block            = "10.1.0.0/24"
              az                              = "eu-west-2a"
              az2                             = "eu-west-2b"
              adminpassword                   = "1234"
              ad_aws_ssm_document_name        = "1234"
              ad_writer_instance_profile_name = "1234"
              naming_suffix                   = "preprod-dq"
              namespace                       = "preprod"
              haproxy_private_ip              = "1.2.3.3"
              haproxy_private_ip2             = "1.2.3.4"

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
              }

              route_table_cidr_blocks     = {
                peering_cidr = "1234"
                ops_cidr     = "10.2.0.0/24"
                acp_vpn      = "1234"
                acp_prod     = "1234"
                acp_ops      = "1234"
                acp_cicd     = "1234"
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
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_apps_vpc_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["cidr_block"], "10.1.0.0/16")

    def test_apps_public_cidr(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["cidr_block"], "10.1.0.0/24")

    def test_az_public_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["availability_zone"], "eu-west-2a")

    def test_name_suffix_ari(self):
        self.assertEqual(self.result['apps']["aws_internet_gateway.AppsRouteToInternet"]["tags.Name"], "igw-apps-preprod-dq")

    def test_name_suffix_appsvpc(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["tags.Name"], "vpc-apps-preprod-dq")

    def test_name_suffix_public_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["tags.Name"], "public-subnet-apps-preprod-dq")

    def test_name_suffix_ad_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.ad_subnet"]["tags.Name"], "ad-subnet-apps-preprod-dq")

    def test_name_suffix_route_table(self):
        self.assertEqual(self.result['apps']["aws_route_table.apps_route_table"]["tags.Name"], "route-table-apps-preprod-dq")

    def test_name_suffix_public_route(self):
        self.assertEqual(self.result['apps']["aws_route_table.apps_public_route_table"]["tags.Name"], "public-route-table-apps-preprod-dq")

    def test_name_suffix_appsnatgw(self):
        self.assertEqual(self.result['apps']["aws_nat_gateway.appsnatgw"]["tags.Name"], "natgw-apps-preprod-dq")

    def test_name_suffix_archive_log(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.log_archive_bucket"]["tags.Name"], "s3-log-archive-bucket-apps-preprod-dq")

    def test_name_suffix_data_archive_log(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.data_archive_bucket"]["tags.Name"], "s3-data-archive-bucket-apps-preprod-dq")

    def test_name_suffix_data_working(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.data_working_bucket"]["tags.Name"], "s3-data-working-bucket-apps-preprod-dq")

    def test_name_suffix_airports_archive(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.airports_archive_bucket"]["tags.Name"], "s3-dq-airports-archive-apps-preprod-dq")

    def test_name_suffix_airports_internal(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.airports_internal_bucket"]["tags.Name"], "s3-dq-airports-internal-apps-preprod-dq")

    def test_name_suffix_airports_working(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.airports_working_bucket"]["tags.Name"], "s3-dq-airports-working-apps-preprod-dq")

    def test_name_suffix_nats_iam_group(self):
        self.assertEqual(self.result['apps']["aws_iam_group.nats"]["name"], "iam-group-nats-apps-preprod-dq")

    def test_name_suffix_nats_iam_group_membership(self):
        self.assertEqual(self.result['apps']["aws_iam_group_membership.nats"]["name"], "iam-group-membership-nats-apps-preprod-dq")

    def test_name_suffix_nats_iam_group_policy(self):
        self.assertEqual(self.result['apps']["aws_iam_group_policy.nats"]["name"], "group-policy-nats-apps-preprod-dq")

    def test_name_suffix_nats_iam_user(self):
        self.assertEqual(self.result['apps']["aws_iam_user.nats"]["name"], "iam-user-nats-apps-preprod-dq")

    def test_name_suffix_rds_deploy_iam_lambda_rds(self):
        self.assertEqual(self.result['apps']['rds_deploy']["aws_iam_role.lambda_rds"]["tags.Name"], "iam-lambda-rds-deploy-apps-preprod-dq")

    def test_name_suffix_rds_deploy_lambda_function(self):
        self.assertEqual(self.result['apps']['rds_deploy']["aws_lambda_function.lambda_rds"]["tags.Name"], "lambda-rds-deploy-apps-preprod-dq")

    def test_name_suffix_rds_deploy_cloudwatch_log_group(self):
        self.assertEqual(self.result['apps']['rds_deploy']["aws_cloudwatch_log_group.lambda_rds"]["tags.Name"], "log-lambda-rds-deploy-apps-preprod-dq")

    def test_name_suffix_oag_archive(self):
        self.assertEqual(self.result['apps']['aws_s3_bucket.oag_archive_bucket']["tags.Name"], "s3-dq-oag-archive-apps-preprod-dq")

    def test_name_suffix_oag_internal(self):
        self.assertEqual(self.result['apps']['aws_s3_bucket.oag_internal_bucket']["tags.Name"], "s3-dq-oag-internal-apps-preprod-dq")

    def test_name_suffix_oag_transform(self):
        self.assertEqual(self.result['apps']['aws_s3_bucket.oag_transform_bucket']["tags.Name"], "s3-dq-oag-transform-apps-preprod-dq")

    def test_name_oag_iam_group(self):
        self.assertEqual(self.result['apps']["aws_iam_group.oag"]["name"], "iam-group-oag-apps-preprod-dq")

    def test_name_oag_iam_group_membership(self):
        self.assertEqual(self.result['apps']["aws_iam_group_membership.oag"]["name"], "iam-group-membership-oag-apps-preprod-dq")

    def test_name_oag_iam_group_policy(self):
        self.assertEqual(self.result['apps']["aws_iam_group_policy.oag"]["name"], "group-policy-oag-apps-preprod-dq")

    def test_name_oag_iam_user(self):
        self.assertEqual(self.result['apps']["aws_iam_user.oag"]["name"], "iam-user-oag-apps-preprod-dq")

    def test_name_acl_archive_bucket(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.acl_archive_bucket"]["tags.Name"], "s3-dq-acl-archive-apps-preprod-dq")

    def test_name_acl_internal_bucket(self):
        self.assertEqual(self.result['apps']["aws_s3_bucket.acl_internal_bucket"]["tags.Name"], "s3-dq-acl-internal-apps-preprod-dq")

    def test_name_acl_iam_group(self):
        self.assertEqual(self.result['apps']["aws_iam_group.acl"]["name"], "iam-group-acl-apps-preprod-dq")

    def test_name_acl_iam_group_membership(self):
        self.assertEqual(self.result['apps']["aws_iam_group_membership.acl"]["name"], "iam-group-membership-acl-apps-preprod-dq")

    def test_name_acl_iam_group_policy(self):
        self.assertEqual(self.result['apps']["aws_iam_group_policy.acl"]["name"], "group-policy-acl-apps-preprod-dq")

    def test_name_acl_iam_user(self):
        self.assertEqual(self.result['apps']["aws_iam_user.acl"]["name"], "iam-user-acl-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_iam_role.lambda_trigger"]["tags.Name"], "iam-lambda-trigger-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_cloudwatch_log_group.lambda_trigger"]["tags.Name"], "log-lambda-trigger-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_lambda_oag_trigger(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_lambda_function.lambda_oag"]["tags.Name"], "lambda-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_input_pipeline_log_lambda_oag(self):
        self.assertEqual(self.result['apps']['oag_input_pipeline']["aws_cloudwatch_log_group.lambda_oag"]["tags.Name"], "log-lambda-oag-input-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-oag-transform-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-oag-transform-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-oag-transform-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-oag-transform-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-oag-transform-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_lambda_athena(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_lambda_function.lambda_athena"]["tags.Name"], "lambda-athena-oag-transform-apps-preprod-dq")

    def test_name_suffix_oag_transform_pipeline_log_lambda_athena(self):
        self.assertEqual(self.result['apps']['oag_transform_pipeline']["aws_cloudwatch_log_group.lambda_log_group_athena"]["tags.Name"], "lambda-log-group-athena-oag-transform-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-acl-input-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-acl-input-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-acl-input-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-acl-input-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-acl-input-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-acl-input-apps-preprod-dq")

    def test_name_suffix_acl_input_pipeline_log_lambda_athena(self):
        self.assertEqual(self.result['apps']['acl_input_pipeline']["aws_cloudwatch_log_group.lambda_log_group_athena"]["tags.Name"], "lambda-log-group-athena-acl-input-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-reference-data-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-reference-data-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-reference-data-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-reference-data-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-reference-data-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_lambda_athena(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_lambda_function.lambda_athena"]["tags.Name"], "lambda-athena-reference-data-apps-preprod-dq")

    def test_name_suffix_reference_data_pipeline_log_lambda_athena(self):
        self.assertEqual(self.result['apps']['reference_data_pipeline']["aws_cloudwatch_log_group.lambda_log_group_athena"]["tags.Name"], "lambda-log-group-athena-reference-data-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_consolidated_schedule_pipeline_log_lambda_athena(self):
        self.assertEqual(self.result['apps']['consolidated_schedule_pipeline']["aws_cloudwatch_log_group.lambda_log_group_athena"]["tags.Name"], "lambda-log-group-athena-consolidated-schedule-apps-preprod-dq")

    def test_name_suffix_api_input_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_input_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-api-input-apps-preprod-dq")

    def test_name_suffix_api_input_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_input_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-api-input-apps-preprod-dq")

    def test_name_suffix_api_input_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['api_input_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-api-input-apps-preprod-dq")

    def test_name_suffix_api_input_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_input_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-api-input-apps-preprod-dq")

    def test_name_suffix_api_input_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_input_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-api-input-apps-preprod-dq")

    def test_name_suffix_api_input_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.result['apps']['api_input_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-api-input-apps-preprod-dq")

    def test_name_suffix_api_record_level_score_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_record_level_score_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-api-record-level-score-apps-preprod-dq")

    def test_name_suffix_api_record_level_score_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_record_level_score_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-api-record-level-score-apps-preprod-dq")

    def test_name_suffix_api_record_level_score_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['api_record_level_score_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-api-record-level-score-apps-preprod-dq")

    def test_name_suffix_api_record_level_score_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_record_level_score_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-api-record-level-score-apps-preprod-dq")

    def test_name_suffix_api_record_level_score_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_record_level_score_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-api-record-level-score-apps-preprod-dq")

    def test_name_suffix_api_record_level_score_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.result['apps']['api_record_level_score_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-api-record-level-score-apps-preprod-dq")

    def test_name_suffix_gait_pipeline_step_function_exec(self):
        self.assertEqual(self.result['apps']['gait_pipeline']["aws_iam_role.step_function_exec"]["tags.Name"], "step-function-exec-gait-apps-preprod-dq")

    def test_name_suffix_gait_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['gait_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-gait-apps-preprod-dq")

    def test_name_suffix_gait_pipeline_lambda_gait(self):
        self.assertEqual(self.result['apps']['gait_pipeline']["aws_lambda_function.lambda_gait"]["tags.Name"], "lambda-gait-apps-preprod-dq")

    def test_name_suffix_gait_pipeline_log_lambda_gait(self):
        self.assertEqual(self.result['apps']['gait_pipeline']["aws_cloudwatch_log_group.lambda_log_group_gait"]["tags.Name"], "lambda-log-group-gait-apps-preprod-dq")

    def test_name_suffix_fms_postgres(self):
        self.assertEqual(self.result['apps']['fms']["aws_db_instance.postgres"]["tags.Name"], "postgres-fms-apps-preprod-dq")

    def test_name_suffix_cross_record_scored_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_cross_record_scored_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-api-cross-record-scored-apps-preprod-dq")

    def test_name_suffix_cross_record_scored_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_cross_record_scored_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-api-cross-record-scored-apps-preprod-dq")

    def test_name_suffix_cross_record_scored_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['api_cross_record_scored_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-api-cross-record-scored-apps-preprod-dq")

    def test_name_suffix_cross_record_scored_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_cross_record_scored_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-api-cross-record-scored-apps-preprod-dq")

    def test_name_suffix_cross_record_scored_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['api_cross_record_scored_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-api-cross-record-scored-apps-preprod-dq")

    def test_name_suffix_cross_record_scored_pipeline_lambda_acl_trigger(self):
        self.assertEqual(self.result['apps']['api_cross_record_scored_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-api-cross-record-scored-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_iam_lambda_trigger(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_iam_role.lambda_role_trigger"]["tags.Name"], "iam-lambda-trigger-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_ssm_lambda_trigger(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_ssm_parameter.lambda_trigger_enabled"]["tags.Name"], "ssm-lambda-trigger-enabled-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_sfn_state_machine(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_sfn_state_machine.sfn_state_machine"]["tags.Name"], "sfn-state-machine-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_lambda_trigger(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_lambda_function.lambda_trigger"]["tags.Name"], "lambda-trigger-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_log_lambda_trigger(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_cloudwatch_log_group.lambda_log_group_trigger"]["tags.Name"], "lambda-log-group-trigger-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_lambda_athena(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_lambda_function.lambda_athena"]["tags.Name"], "lambda-athena-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_log_lambda_athena(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_cloudwatch_log_group.lambda_log_group_athena"]["tags.Name"], "lambda-log-group-athena-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_iam_lambda_rds(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_iam_role.lambda_rds"]["tags.Name"], "iam-lambda-rds-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_lambda_rds(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_lambda_function.lambda_rds"]["tags.Name"], "lambda-rds-internal-reporting-apps-preprod-dq")

    def test_name_suffix_internal_reporting_pipeline_log_lambda_rds(self):
        self.assertEqual(self.result['apps']['internal_reporting_pipeline']["aws_cloudwatch_log_group.lambda_rds"]["tags.Name"], "log-lambda-rds-internal-reporting-apps-preprod-dq")

if __name__ == '__main__':
    unittest.main()
