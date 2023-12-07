variable "cidr_block" {
}

variable "public_subnet_cidr_block" {
}

variable "ad_subnet_cidr_block" {
}

variable "az" {
}

variable "az2" {
}

variable "adminpassword" {
}

variable "ad_aws_ssm_document_name" {
}

variable "ad_writer_instance_profile_name" {
}

variable "naming_suffix" {
}

variable "haproxy_private_ip" {
}

variable "haproxy_private_ip2" {
}

variable "namespace" {
}

variable "account_id" {
  type = map(string)
}

variable "ad_sg_cidr_ingress" {
  description = "List of CIDR block ingress to AD machines SG"
  type        = list(string)
}

variable "region" {
  default = "eu-west-2"
}

variable "vpc_peering_connection_ids" {
  description = "List of peering VPC connection ids."
  type        = map(string)
}

variable "route_table_cidr_blocks" {
  description = "Map of CIDR blocks for the Apps private route table."
  type        = map(string)
}

variable "s3_bucket_name" {
  description = "Map of the S3 bucket names"
  type        = map(string)
}

variable "s3_bucket_acl" {
  description = "Map of the S3 bucket canned ACLs"
  type        = map(string)
}

variable "rds_db_name" {
  description = "Supplies the database name for a Postgres deployment"
  default     = "internal_tableau"
}

variable "dq_pipeline_ops_readwrite_database_name_list" {
  default = [
    "reference_data",
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
    "fms",
    "snsgb",
    "asn_maritime",
    "aftc_sc",
    "pnr",
    "ais_marinetraffic",
  ]
}

variable "dq_pipeline_ops_unscoped_readwrite_database_name_list" {
  default = [
    "fedat_reporting",
    "pnr_reporting",
    "consolidated_schedule_reporting",
  ]
}

variable "dq_pipeline_athena_readwrite_database_name_list" {
  default = [
    "reference_data",
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
    "fms",
    "nats_internal",
    "freight",
    "gait_working",
    "snsgb",
    "asn_maritime",
    "aftc_sc",
    "pnr",
    "ais_marinetraffic",
  ]
}

variable "dq_pipeline_athena_unscoped_readwrite_database_name_list" {
  default = [
    "fedat_reporting",
    "pnr_reporting",
    "consolidated_schedule_reporting",
  ]
}

variable "dq_pipeline_ops_readonly_database_name_list" {
  default = ["api_input"]
}

variable "dq_pipeline_ops_readwrite_bucket_list" {
  default = [
    "s3-dq-reference-data-internal",
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
    "s3-dq-fms-working",
    "s3-dq-snsgb-internal",
    "s3-dq-asn-internal",
    "s3-dq-asn-marine-internal",
    "s3-dq-pnr-internal",
    "s3-dq-ais-internal",
    "s3-dq-test"
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

variable "kms_key_s3" {
  type        = map(string)
  description = "The ARN of the KMS key that is used to encrypt S3 buckets"
  default = {
    test    = "arn:aws:kms:eu-west-2:797728447925:key/ad7169c4-6d6a-4d21-84ee-a3b54f4bef87"
    notprod = "arn:aws:kms:eu-west-2:483846886818:key/24b0cd4f-3117-4e9b-ada8-fa46e7fd6d70"
    prod    = "arn:aws:kms:eu-west-2:337779336338:key/ae75113d-f4f6-49c6-a15e-e8493fda0453"
  }
}
