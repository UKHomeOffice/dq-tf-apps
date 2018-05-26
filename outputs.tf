output "appsvpc_id" {
  value = "${aws_vpc.appsvpc.id}"
}

output "appsvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "appssubnet_cidr_block" {
  value = "${var.public_subnet_cidr_block}"
}

output "apps_natgw_id" {
  value = "${aws_nat_gateway.appsnatgw.id}"
}

output "outputs" {
  value = {
    windows = "${aws_instance.win.*.public_dns}"
  }
}

output "ad_subnet_id" {
  value = "${aws_subnet.ad_subnet.id}"
}

output "log_archive_bucket_id" {
  value = "${aws_s3_bucket.log_archive_bucket.id}"
}

output "log_archive_bucket_arn" {
  value = "${aws_s3_bucket.log_archive_bucket.arn}"
}

output "iam_roles" {
  value = "${concat(module.data_ingest.iam_roles, module.data_pipeline.iam_roles, module.data_feeds.iam_roles, module.external_tableau.iam_roles, module.internal_tableau.iam_roles, module.gpdb.iam_roles)}"
}
