resource "aws_kms_key" "this" {
  description = var.kms_key.description
  deletion_window_in_days = var.kms_key.deletion_window_in_days
  enable_key_rotation = var.kms_key.enable_key_rotation

  tags = var.tags
}

data "aws_region" "state" {
}

resource "aws_s3_bucket" "state" {
  bucket_prefix = var.state_bucket_prefix
  acl = "private"
  force_destroy = var.s3_bucket.force_destroy
  versioning {
    enabled = true
    mfa_delete = var.s3_bucket.mfa_delete
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.this.arn
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}