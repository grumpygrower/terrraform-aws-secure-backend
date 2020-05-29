locals {
  lock_key_id = "LockID"
}

resource "aws_dynamodb_table" "lock" {
  name = var.dynamodb_table_name
  billing_mode = var.dynamodb_table_billing_mode
  hash_key = local.lock_key_id
  attribute {
    name = local.lock_key_id
    type = "S"
  }

  tags = var.tags
}