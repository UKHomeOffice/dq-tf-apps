output "vpc_id" {
  value = "${aws_vpc.appsvpc.id}"
}

output "vpc_cidr_block" {
  value = "${var.cidr_block}"
}
