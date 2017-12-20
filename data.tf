data "aws_ami" "win" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "Windows_Server-2012-R2_RTM-English-64Bit-Base-*",
    ]
  }

  owners = [
    "amazon",
  ]
}

data "aws_availability_zones" "available" {}

data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "RHEL-7.4*",
    ]
  }

  owners = [
    "309956199498",
  ]
}
