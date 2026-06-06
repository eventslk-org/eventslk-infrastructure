# Remote backend — values injected via -backend-config in CI.
# The placeholder values below are overridden at init time.

terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "eventslk-tf-state"
    key            = "eventslk/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eventslk-tf-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
