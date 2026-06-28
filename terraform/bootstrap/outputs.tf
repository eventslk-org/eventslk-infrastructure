output "state_bucket_name" {
  description = "Name of the S3 bucket holding Terraform remote state."
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state bucket."
  value       = aws_s3_bucket.state.arn
}

output "lock_table_name" {
  description = "DynamoDB table used for Terraform state locking."
  value       = aws_dynamodb_table.locks.name
}

output "lock_table_arn" {
  description = "ARN of the DynamoDB lock table."
  value       = aws_dynamodb_table.locks.arn
}

output "kms_key_arn" {
  description = "ARN of the CMK encrypting state (null when KMS encryption is disabled)."
  value       = var.enable_kms_encryption ? aws_kms_key.state[0].arn : null
}

output "backend_config" {
  description = "Copy-paste snippet for the consuming stack's backend \"s3\" block."
  value = {
    bucket         = aws_s3_bucket.state.id
    key            = "${var.project}/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = aws_dynamodb_table.locks.name
    encrypt        = true
    kms_key_id     = var.enable_kms_encryption ? aws_kms_key.state[0].arn : null
  }
}
