variable "cidr_block" {}
variable "vpc_subnet1_cidr_block" {}
variable "vpc_subnet2_cidr_block" {}
variable "vpc_subnet3_cidr_block" {}
variable "vpc_subnet4_cidr_block" {}
variable "vpc_subnet5_cidr_block" {}
variable "vpc_subnet6_cidr_block" {}
variable "vpc_subnet7_cidr_block" {}
variable "vpc_subnet8_cidr_block" {}
variable "az" {}
variable "name_prefix" {}

locals {
  name_prefix = "${var.name_prefix}apps-"
}

resource "aws_vpc" "appsvpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${local.name_prefix}vpc"
  }
}

resource "aws_internet_gateway" "AppsRouteToInternet" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  tags {
    Name = "${local.name_prefix}igw"
  }
}

resource "aws_subnet" "AppsSubnet1" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet1_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet1"
  }
}

resource "aws_subnet" "AppsSubnet2" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet2_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet2"
  }
}

resource "aws_subnet" "AppsSubnet3" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet3_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet3"
  }
}

resource "aws_subnet" "AppsSubnet4" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet4_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet4"
  }
}

resource "aws_subnet" "AppsSubnet5" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet5_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet5"
  }
}

resource "aws_subnet" "AppsSubnet6" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet6_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet6"
  }
}

resource "aws_subnet" "AppsSubnet7" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet7_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet7"
  }
}

resource "aws_subnet" "AppsSubnet8" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.vpc_subnet8_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet8"
  }
}
