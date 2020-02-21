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
    "drt",
    "airports_working",
    "airports_input",
    "carrier_portal",
    "fms",
  ]
}

variable "dq_pipeline_athena_readwrite_database_name_list" {
  default = ["reference_data",
    "acl",
    "consolidated_schedule",
    "api_record_level_score",
    "api_cross_record_scored",
    "api_input",
    "oag_transform",
    "internal_reporting",
    "drt",
    "airports_working",
    "airports_input",
    "carrier_portal",
    "fms",
    "nats_internal",
    "freight",
    "gait_working",
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
    "s3-dq-drt-working",
    "s3-dq-reporting-internal-working",
    "s3-dq-airports-working",
    "s3-dq-airports-internal",
    "s3-dq-carrier-portal-working",
    "s3-dq-fms-working",
  ]
}

variable "dq_pipeline_ops_readonly_bucket_list" {
  default = ["s3-dq-api-internal"]
}

variable "s3_httpd_config_bucket" {
  description = "HTTPD config bucket ID"
}

variable "s3_httpd_config_bucket_key" {
  description = "HTTPD config bucket KMS Key ARN"
}

variable "haproxy_config_bucket" {
  description = "HAPROXY config bucket ID"
}

variable "haproxy_config_bucket_key" {
  description = "HAPROXY config bucket KMS key"
}

variable "athena_maintenance_bucket" {
  description = "Athena Maintenance Bucket Name"
  default     = "s3-dq-athena-maintenance-bucket"
}

variable "athena_adhoc_maintenance_database" {
  description = "Athena maintenance database name"
  default     = "api_input"
}

variable "athena_adhoc_maintenance_table" {
  description = "Athena maintenance table name"
  default     = "input_file_api"
}

variable "athena_log_prefix" {
  description = "Keyprefix for Athena maintenance task"
  default     = "app"
}
