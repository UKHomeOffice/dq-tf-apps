# DQ Terraform Module

This module describes required VPC components for testing app modules against the DQ VPC.

**Content overview**

**main.tf**

This file has most of the App modules along with basic VPC components:
- Provider
- VPC
- Private and Public Route table
- Elastic IP
- NAT gateway
- Public subnet and route table association

**s3.tf**

This file consists of encrypted S3 buckets, IAM policy and `random_string` generator along with VPC S3 endpoints for logs and data feeds.

**data.tf**

Data lookup for EC2 instance AMIs.

**ad_instance.tf**

This set of resources creates a couple of EC2 machines in their subnet, associate them to the main route table then adds them to a Security Group and joins them to Microsoft AD.

**outputs.tf**

Various data outputs for other modules/consumers.

**variables.tf**

Input data for resources within this repo.

**tests/apps_test.py**

Code and resource tester with mock data. It can be expanded by adding further definitions to the unit.

**How to run/deploy**

`terraform plan`
`terraform apply`
