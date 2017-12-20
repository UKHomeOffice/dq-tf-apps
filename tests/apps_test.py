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

              cidr_block                  = "10.1.0.0/16"
              public_subnet_cidr_block    = "10.1.0.0/24"
              ad_subnet_cidr_block        = "10.1.0.0/24"
              az                          = "eu-west-2a"
              name_prefix                 = "dq-"
              ad_aws_ssm_document_name    = "1234"
              ad_writer_instance_profile_name = "1234"
              route_table_cidr_blocks     = {
                peering_cidr = "1234"
                ops_cidr = "1234"
                acp_vpn = "1234"
                acp_prod = "1234"
                acp_ops = "1234"
                acp_cicd = "1234"
              }
              vpc_peering_connection_ids  = {
                peering_to_peering = "1234"
                peering_to_ops     = "1234"
              }

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

    def test_name_prefix_ari(self):
        self.assertEqual(self.result['apps']["aws_internet_gateway.AppsRouteToInternet"]["tags.Name"], "dq-apps-igw")

    def test_name_prefix_appsvpc(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["tags.Name"], "dq-apps-vpc")

    def test_name_prefix_public_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["tags.Name"], "dq-apps-public-subnet")

    def test_name_prefix_ad_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.ad_subnet"]["tags.Name"], "dq-apps-ad-subnet")

    def test_name_prefix_route_table(self):
        self.assertEqual(self.result['apps']["aws_route_table.apps_route_table"]["tags.Name"], "dq-apps-route-table")

    def test_name_prefix_public_route(self):
        self.assertEqual(self.result['apps']["aws_route_table.apps_public_route_table"]["tags.Name"], "dq-apps-public-route-table")

    def test_name_prefix_appsnatgw(self):
        self.assertEqual(self.result['apps']["aws_nat_gateway.appsnatgw"]["tags.Name"], "dq-apps-natgw")

if __name__ == '__main__':
    unittest.main()
