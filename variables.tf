variable "cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "az" {}
variable "name_prefix" {}

variable "vpc_peering_connection_ids" {
  description = "List of peering VPC connection ids."
  type        = "map"
}

variable "route_table_cidr_blocks" {
  description = "Map of CIDR blocks for the Apps private route table."
  type        = "map"
}
