variable "cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "ad_subnet_cidr_block" {}
variable "az" {}
variable "name_prefix" {}
variable "ad_aws_ssm_document_name" {}
variable "ad_writer_instance_profile_name" {}

variable "service" {
  default = "dg"
}

variable "environment" {
  default = "preprod"
}

variable "vpc_peering_connection_ids" {
  description = "List of peering VPC connection ids."
  type        = "map"
}

variable "route_table_cidr_blocks" {
  description = "Map of CIDR blocks for the Apps private route table."
  type        = "map"
}
