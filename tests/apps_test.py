# pylint: disable=missing-docstring, line-too-long, protected-access
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
              dqdb_apps_cidr_block        = "10.1.2.0/24"
              mdm_apps_cidr_block         = "10.1.10.0/24"
              int_dashboard_cidr_block    = "10.1.12.0/24"
              ext_dashboard_cidr_block    = "10.1.14.0/24"
              az                          = "eu-west-2a"
              name_prefix                 = "dq-"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_apps_vpc_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["cidr_block"], "10.1.0.0/16")

    def test_apps_public_subnet_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["cidr_block"], "10.1.0.0/24")

    def test_apps_dqdb_apps_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.dqdb_apps"]["cidr_block"], "10.1.2.0/24")

    def test_apps_mdm_apps_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.mdm_apps"]["cidr_block"], "10.1.10.0/24")

    def test_apps_int_dashboard_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.int_dashboard"]["cidr_block"], "10.1.12.0/24")

    def test_apps_ext_dashboard_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.ext_dashboard"]["cidr_block"], "10.1.14.0/24")

    def test_az_public_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["availability_zone"], "eu-west-2a")

    def test_az_dqdb_apps(self):
        self.assertEqual(self.result['apps']["aws_subnet.dqdb_apps"]["availability_zone"], "eu-west-2a")

    def test_az_mdm_apps(self):
        self.assertEqual(self.result['apps']["aws_subnet.mdm_apps"]["availability_zone"], "eu-west-2a")

    def test_az_int_dashboard(self):
        self.assertEqual(self.result['apps']["aws_subnet.int_dashboard"]["availability_zone"], "eu-west-2a")

    def test_az_ext_dashboard(self):
        self.assertEqual(self.result['apps']["aws_subnet.ext_dashboard"]["availability_zone"], "eu-west-2a")

    def test_name_prefix_AppsRouteToInternet(self):
        self.assertEqual(self.result['apps']["aws_internet_gateway.AppsRouteToInternet"]["tags.Name"], "dq-apps-igw")

    def test_name_prefix_appsvpc(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["tags.Name"], "dq-apps-vpc")

    def test_name_prefix_public_subnet(self):
        self.assertEqual(self.result['apps']["aws_subnet.public_subnet"]["tags.Name"], "dq-apps-public-subnet")

    def test_name_prefix_dqdb_apps(self):
        self.assertEqual(self.result['apps']["aws_subnet.dqdb_apps"]["tags.Name"], "dq-apps-dqdb-subnet")

    def test_name_prefix_mdm_apps(self):
        self.assertEqual(self.result['apps']["aws_subnet.mdm_apps"]["tags.Name"], "dq-apps-mdm-subnet")

    def test_name_prefix_int_dashboard(self):
        self.assertEqual(self.result['apps']["aws_subnet.int_dashboard"]["tags.Name"], "dq-apps-int-dashboard-subnet")

    def test_name_prefix_ext_dashboard(self):
        self.assertEqual(self.result['apps']["aws_subnet.ext_dashboard"]["tags.Name"], "dq-apps-ext-dashboard-subnet")

    def test_name_prefix_appsnatgw(self):
        self.assertEqual(self.result['apps']["aws_nat_gateway.appsnatgw"]["tags.Name"], "dq-apps-natgw")

if __name__ == '__main__':
    unittest.main()
