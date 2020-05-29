data "aws_iam_policy_document" "terraform_policy" {
  version = "2012-10-17"
  statement {
    sid = "terraformAllowS3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [ aws_s3_bucket.state.arn ]
  }

  statement {
    sid = "terraformAllowS3GetPut"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [ aws_s3_bucket.state.arn ]
  }

  statement {
    sid = "terraformAllowDynamoDbGetPutDelete"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      aws_dynamodb_table.lock.arn
    ]
  }
  statement {
    sid = "terraformAllowKMSListKeys"
    effect = "Allow"
    actions = [
      "kms:ListKeys"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "terraformAllowKMSEncryptDecryptDescribeGenDataKey"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    resources = [
      aws_kms_key.this.arn
    ]
  }
}
resource "aws_iam_policy" "terraform" {
  name_prefix = var.terraform_iam_policy_name_prefix
  policy = data.aws_iam_policy_document.terraform_policy.json
}