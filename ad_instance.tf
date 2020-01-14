resource "aws_subnet" "ad_subnet" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.ad_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "ad-subnet-${local.naming_suffix}"
  }
}

resource "aws_route_table_association" "apps_route_table_association" {
  subnet_id      = "${aws_subnet.ad_subnet.id}"
  route_table_id = "${aws_route_table.apps_route_table.id}"
}
