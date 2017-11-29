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

              cidr_block             = "10.1.0.0/16"
              vpc_subnet1_cidr_block = "10.1.0.0/24"
              vpc_subnet2_cidr_block = "10.1.2.0/24"
              vpc_subnet3_cidr_block = "10.1.4.0/24"
              vpc_subnet4_cidr_block = "10.1.6.0/24"
              vpc_subnet5_cidr_block = "10.1.8.0/24"
              vpc_subnet6_cidr_block = "10.1.10.0/24"
              vpc_subnet7_cidr_block = "10.1.12.0/24"
              vpc_subnet8_cidr_block = "10.1.14.0/24"
              az                     = "eu-west-2a"
              name_prefix            = "dq-"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_apps_vpc_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["cidr_block"], "10.1.0.0/16")

    def test_apps_subnet1_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet1"]["cidr_block"], "10.1.0.0/24")

    def test_apps_subnet2_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet2"]["cidr_block"], "10.1.2.0/24")

    def test_apps_subnet3_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet3"]["cidr_block"], "10.1.4.0/24")

    def test_apps_subnet4_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet4"]["cidr_block"], "10.1.6.0/24")

    def test_apps_subnet5_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet5"]["cidr_block"], "10.1.8.0/24")

    def test_apps_subnet6_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet6"]["cidr_block"], "10.1.10.0/24")

    def test_apps_subnet7_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet7"]["cidr_block"], "10.1.12.0/24")

    def test_apps_subnet8_cidr_block(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet8"]["cidr_block"], "10.1.14.0/24")

    def test_az_subnet1(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet1"]["availability_zone"], "eu-west-2a")

    def test_az_subnet2(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet2"]["availability_zone"], "eu-west-2a")

    def test_az_subnet3(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet3"]["availability_zone"], "eu-west-2a")

    def test_az_subnet4(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet4"]["availability_zone"], "eu-west-2a")

    def test_az_subnet5(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet5"]["availability_zone"], "eu-west-2a")

    def test_az_subnet6(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet6"]["availability_zone"], "eu-west-2a")

    def test_az_subnet7(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet7"]["availability_zone"], "eu-west-2a")

    def test_az_subnet8(self):
        self.assertEqual(self.result['apps']["aws_subnet.AppsSubnet8"]["availability_zone"], "eu-west-2a")

    def test_name_prefix_AppsRouteToInternet(self):
        self.assertEqual(self.result['apps']["aws_internet_gateway.AppsRouteToInternet"]["tags.Name"], "dq-apps-igw")

    def test_name_prefix_appsvpc(self):
        self.assertEqual(self.result['apps']["aws_vpc.appsvpc"]["tags.Name"], "dq-apps-vpc")

if __name__ == '__main__':
    unittest.main()
