variable "aws_region" {
  description = "AWS region where the state bucket and lock table live."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name, used for default tagging and resource naming."
  type        = string
  default     = "eventslk"
}

variable "environment" {
  description = "Environment label for the backend (e.g. shared, prod, dev)."
  type        = string
  default     = "shared"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform remote state."
  type        = string
  default     = "eventslk-tf-state"

  validation {
    condition     = length(var.state_bucket_name) >= 3 && length(var.state_bucket_name) <= 63
    error_message = "S3 bucket names must be between 3 and 63 characters."
  }
}

variable "lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  type        = string
  default     = "eventslk-tf-locks"
}

variable "force_destroy_bucket" {
  description = "Allow terraform destroy to remove the bucket even if it still contains objects. Keep false in production."
  type        = bool
  default     = false
}

variable "enable_kms_encryption" {
  description = "When true, encrypt the state bucket with a dedicated customer-managed KMS key instead of SSE-S3."
  type        = bool
  default     = true
}

variable "noncurrent_version_retention_days" {
  description = "Days to retain non-current state object versions before permanent deletion."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Additional tags applied to every resource."
  type        = map(string)
  default     = {}
}
