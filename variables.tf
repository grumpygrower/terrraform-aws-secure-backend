variable "terraform_iam_policy_name_prefix" {
  description = "Create an unique name and appends a prefix."
  default = "terraform"
}

# DynamoDB
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking."
  default = "terraform_rs_lock"
}

# See https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BillingModeSummary.html for more info
variable "dynamodb_table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  default = "PAY_PER_REQUEST"
}

# Tags
variable "tags" {
  description = "Tags to assign to a resource."
  default = {
    Terraform = "true"
  }
}

# KMS
variable "kms_key" {
  type = object({
    description = string
    deletion_window_in_days = number
    enable_key_rotation = bool
  })

  default = {
      description = "The key used to encrypt the remote state bucket."
      deletion_window_in_days = 10
      enable_key_rotation = true
    }

  validation {
    condition = var.kms_key.deletion_window_in_days > 7 || var.kms_key.deletion_window_in_days < 30
    error_message = "The key deletion window should be between 7 and 30 days."
  }
}

# S3 bucket
variable "state_bucket_prefix" {
  description = "Creates a unique state bucket name beginning with the specified prefix."
  default     = "tf-remote-state"
}

variable "s3_bucket" {

  type = object({
    force_destroy = bool
    mfa_delete = bool
  })
  default = {
      force_destroy = true
      mfa_delete = false
    }
}