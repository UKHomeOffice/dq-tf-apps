variable "cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "ad_subnet_cidr_block" {}
variable "az" {}
variable "az2" {}
variable "adminpassword" {}
variable "ad_aws_ssm_document_name" {}
variable "ad_writer_instance_profile_name" {}
variable "naming_suffix" {}

variable "ad_sg_cidr_ingress" {
  description = "List of CIDR block ingress to AD machines SG"
  type        = "list"
}

variable "region" {
  default = "eu-west-2"
}

variable "vpc_peering_connection_ids" {
  description = "List of peering VPC connection ids."
  type        = "map"
}

variable "route_table_cidr_blocks" {
  description = "Map of CIDR blocks for the Apps private route table."
  type        = "map"
}

variable "s3_bucket_name" {
  description = "Map of the S3 bucket names"
  type        = "map"
}

variable "s3_bucket_acl" {
  description = "Map of the S3 bucket canned ACLs"
  type        = "map"
}
