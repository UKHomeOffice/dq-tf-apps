resource "aws_kms_key" "log_archive_bucket_key" {
  description             = "This key is used to encrypt Archive Log bucket objects"
  deletion_window_in_days = 7

  tags = {
    Name             = "s3-${var.service}-archive-kms-key-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "log_archive_bucket" {
  bucket = "${var.s3_bucket_name["archive_log"]}"
  acl    = "${var.s3_bucket_acl["archive_log"]}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.log_archive_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name             = "s3-${var.service}-archive-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_vpc_endpoint" "logs_s3_endpoint" {
  vpc_id          = "${aws_vpc.appsvpc.id}"
  route_table_ids = ["${aws_route_table.apps_route_table.id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}
