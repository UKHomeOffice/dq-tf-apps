output "appsvpc_id" {
  value = aws_vpc.appsvpc.id
}

output "appsvpc_cidr_block" {
  value = var.cidr_block
}

output "appssubnet_cidr_block" {
  value = var.public_subnet_cidr_block
}

output "apps_natgw_id" {
  value = aws_nat_gateway.appsnatgw.id
}

output "ad_subnet_id" {
  value = aws_subnet.ad_subnet.id
}

output "log_archive_bucket_id" {
  value = aws_s3_bucket.log_archive_bucket.id
}

output "log_archive_bucket_arn" {
  value = aws_s3_bucket.log_archive_bucket.arn
}

#output "iam_roles" {
#  value = concat(
#    module.external_tableau.iam_roles,
#    module.internal_tableau.iam_roles,
#  )
#}

output "athena_log_bucket" {
  value = aws_s3_bucket.athena_log_bucket.id
}

output "aws_bucket_key" {
  value = aws_kms_key.bucket_key.arn
}

output "dq_pipeline_ops_readwrite_database_name_list" {
  value = var.dq_pipeline_ops_readwrite_database_name_list
}

output "dq_pipeline_ops_readonly_database_name_list" {
  value = var.dq_pipeline_ops_readonly_database_name_list
}

output "dq_pipeline_ops_readwrite_bucket_list" {
  value = var.dq_pipeline_ops_readwrite_bucket_list
}

output "dq_pipeline_ops_readonly_bucket_list" {
  value = var.dq_pipeline_ops_readonly_bucket_list
}

