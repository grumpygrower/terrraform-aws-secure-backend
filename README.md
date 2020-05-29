---
title: Terraform AWS Remote State s3 Backend  
version: 0.0.1  
author: grumpygrower <grumpygrower@protonmail.com>
date: '2020-05-29'
---

# Terraform AWS Remote State s3 Backend

This Terraform module can be used to set up remote state management 
using S3 backend form your account. It will create the S3 bucket with
encryption enabled via KMS and create a DynamoDB table for state locking.
It will also create an IAM policy to allow Terraform to use this service.

## Usage
This module outputs terraform_iam_policy which can be attached to IAM users,
groups or roles running Terraform. This will allow the entity accessing 
remote state files and the locking table.

```
provider "aws" {
  region = "eu-west-2"
}

module "remote_state" {
  source = "github.com/grumpygrower/terraform-aws-s3-backend.git"
  providers = {
    aws = aws
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}
```

Once the resources are created, you can configure your terraform environment
to use the S3 backend as follows.

```
terraform {
    backend "s3" {
        bucket = state_bucket.bucket
        key = "path/terraform.tfstate"
        region "eu-west-2"
        encrypt = true
        kms_key_id = kms_key.id
    }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| terraform_iam_policy_name_prefix | Create an unique name and appends a prefix | String | terraform | false |
| dynamodb_table_name | The name of the DynamoDB table used for state locking. | String | terraform_rs_lock | false |
| dynamodb_table_billing_mode | Controls how you are charged for read and write throughput and how you manage capacity. Must be either PAY_PER_REQUEST or PROVISIONED | String | PAY_PER_REQUEST | false |
| tags | Tags to assign to a resource. | Map | { "Terraform": "true" } | false |
| kms_key | Collection of variables related to KMS | Object | [See below](#markdown-header-kms_key) | false |
| state_bucket_prefix | Creates a unique state bucket name beginning with the specified prefix. | String | tf-remote-state| false |
| s3_bucket | Collection of variables related to the S3 Bucket. | Object | [See below](#markdown-header-s3_bucket) | false |


### kms_key
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| description | The description of the key as viewed in AWS console. | String | The key used to encrypt the remote state bucket. | false |
| deletion_window_in_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. | Integer | 10 | false |
| enable_key_rotation | Specifies whether key rotation is enabled. | Boolean | true | false |

### s3_Bucket

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| force_destroy | A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable. | Boolean | true | false |
| mfa_delete | If a bucket's versioning configuration is MFA Delete–enabled, the bucket owner must include the x-amz-mfa request header in requests to permanently delete an object version or change the versioning state of the bucket. | Boolean | false | false |
 


## outputs
| Name | Description |
|------|-------------|
| kms_key | The KMS master key used to encrypt state. |
| state_bucket | The S3 bucket to store remote state. |
| dynamodb_table | Dynamodb table used to lock state. |
| terraform_iam_policy | IAM policy to access remote state environment. | 
