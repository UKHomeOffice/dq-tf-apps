variable "cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "az" {}
variable "name_prefix" {}
variable "vpc_peering_to_peering_id" {}

variable "route_table_cidr_blocks" {
  description = "Map of CIDR blocks for the Apps private route table."
  type        = "map"
}
