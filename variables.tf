variable "cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "ad_subnet_cidr_block" {}
variable "az" {}
variable "az2" {}
variable "adminpassword" {}
variable "ad_aws_ssm_document_name" {}
variable "ad_writer_instance_profile_name" {}
variable "naming_suffix" {}
variable "haproxy_private_ip" {}
variable "haproxy_private_ip2" {}
variable "namespace" {}

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

variable "rds_db_name" {
  description = "Supplies the database name for a Postgres deployment"
  default     = "internal_tableau"
}

variable "dq_pipeline_ops_readwrite_database_name_list" {
  default = ["reference_data",
    "acl",
    "consolidated_schedule",
    "api_record_level_score",
    "api_cross_record_scored",
    "api_input",
    "oag_transform",
    "internal_reporting",
  ]
}

variable "dq_pipeline_ops_readonly_database_name_list" {
  default = ["api_input"]
}

variable "dq_pipeline_ops_readwrite_bucket_list" {
  default = ["s3-dq-reference-data-internal",
    "s3-dq-acl-internal",
    "s3-dq-oag-internal",
    "s3-dq-oag-transform",
    "s3-dq-consolidated-schedule",
    "s3-dq-api-record-level-scoring",
    "s3-dq-api-internal",
    "s3-dq-cross-record-scored",
    "s3-dq-raw-file-index-internal",
    "s3-dq-athena-log",
  ]
}

variable "dq_pipeline_ops_readonly_bucket_list" {
  default = ["s3-dq-api-internal"]
}

variable "s3_haproxy_config_bucket" {
  description = "Haproxy config bucket ID"
}

variable "s3_haproxy_config_bucket_key" {
  description = "Haproxy config bucket KMS Key ARN"
}

#########################################
# begin rds instance monitoring variables
#########################################

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = "string"
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = "string"
  default     = 80
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = "string"
  default     = 64
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = "string"
  default     = 64000000

  # 64 Megabyte in Bytes
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = "string"
  default     = 2000000000

  # 2 Gigabyte in Bytes
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = "string"
  default     = 256000000

  # 256 Megabyte in Bytes
}
