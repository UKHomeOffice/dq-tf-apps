locals {
  name_prefix = "${var.name_prefix}apps-"
}

resource "aws_vpc" "appsvpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${local.name_prefix}vpc"
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

resource "aws_subnet" "dqdb_apps" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.dqdb_apps_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}dqdb-subnet"
  }
}

resource "aws_subnet" "ext_feed_apps" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.ext_feed_apps_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}ext-feed-subnet"
  }
}

resource "aws_subnet" "data_ingest_apps" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.data_ingest_apps_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}data-ingest-subnet"
  }
}

resource "aws_subnet" "data_pipe_apps" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.data_pipe_apps_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}data-pipe-subnet"
  }
}

resource "aws_subnet" "mdm_apps" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.mdm_apps_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}mdm-subnet"
  }
}

resource "aws_subnet" "int_dashboard" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.int_dashboard_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}int-dashboard-subnet"
  }
}

resource "aws_subnet" "ext_dashboard" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.ext_dashboard_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}ext-dashboard-subnet"
  }
}
