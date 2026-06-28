# Bootstrap stack uses a local backend on purpose.
# It provisions the remote state primitives (S3 + DynamoDB) that the
# main stack consumes via its S3 backend, so it cannot depend on them itself.
terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project
        Environment = var.environment
        ManagedBy   = "terraform"
        Component   = "tf-backend-bootstrap"
      },
      var.tags,
    )
  }
}
