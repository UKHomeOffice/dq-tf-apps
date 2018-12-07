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

              s3_bucket_name = {
                archive_log  = "abcd"
                archive_data = "abcd"
                working_data = "abcd"
                landing_data = "abcd"
              }

              s3_bucket_acl = {
                archive_log  = "abcd"
                archive_data = "abcd"
                working_data = "abcd"
                landing_data = "abcd"
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

if __name__ == '__main__':
    unittest.main()
