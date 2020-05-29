output "kms_key" {
  description = "The KMS master key used to encrypt state."
  value = aws_kms_key.this
}

output "state_bucket" {
  description = "The S3 bucket to store remote state."
  value = aws_s3_bucket.state
}

output "dynamodb_table" {
  description = "Dynamodb table used to lock state."
  value = aws_dynamodb_table.lock
}

output "terraform_iam_policy" {
  description = "IAM policy to access remote state environment."
  value = aws_iam_policy.terraform
}