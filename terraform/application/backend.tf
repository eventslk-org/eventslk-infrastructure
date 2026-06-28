terraform {
  backend "s3" {
    bucket         = "eventslk-tf-state"
    key            = "eventslk/application/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eventslk-tf-locks"
    encrypt        = true
  }
}
