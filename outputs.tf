output "appsvpc_id" {
  value = "${aws_vpc.appsvpc.id}"
}

output "appsvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "apps_route_table" {
  value = "${aws_route_table.apps_route_table.id}"
}
