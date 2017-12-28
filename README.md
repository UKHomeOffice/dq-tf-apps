# DQ Terraform Apps module

[![Build Status](https://drone.digital.homeoffice.gov.uk/api/badges/UKHomeOffice/dq-tf-apps/status.svg)](https://drone.digital.homeoffice.gov.uk/UKHomeOffice/dq-tf-apps)

This module describes required VPC components for deploying our app modules into the DQ AWS environments.

It can be run against both Production and non-Production environments by setting a variable at runtime to switch the provider used.

## Content overview

This repo controls the deployment of our application modules.

It consists of the following core elements:

### main.tf

This file has most of the App modules along with basic VPC components:
- Provider
- VPC
- Private and Public Route table
- Elastic IP
- NAT gateway
- Public subnet and route table association

### s3.tf

This file consists of encrypted S3 buckets, IAM policy and `random_string` generator along with VPC S3 endpoints for logs and data feeds.

### data.tf

Data lookup for EC2 instance AMIs.

### ad_instance.tf

This set of resources creates a couple of EC2 machines in their subnet, associate them to the main route table then adds them to a Security Group and joins them to Microsoft AD.

### outputs.tf

Various data outputs for other modules/consumers.

### variables.tf

Input data for resources within this repo.

### tests/apps_test.py

Code and resource tester with mock data. It can be expanded by adding further definitions to the unit.

## User guide

### Prepare your local environment

This project currently depends on:

* drone v0.5+dev
* terraform v0.11.1+
* terragrunt v0.13.21+
* python v3.6.3+

Please ensure that you have the correct versions installed (it is not currently tested against the latest version of Drone)

### How to run/deploy

To run the scripts from your local machine:

```
# export/set variables
terragrunt plan
terragrunt apply
```

## FAQs

### The remote state isn't updating, what do I do?

If the CI process appears to be stuck with a stale `tf state` then run the following command to force a refresh:

```
terragrunt refresh
```
