// Terraform remote backend — S3 state storage with DynamoDB locking.
// Bucket, region, and DynamoDB table are supplied at init time via
// -backend-config flags (see CI workflow). The key is static per workspace.

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "eventslk/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-terraform-locks"
    encrypt        = true
  }
}

/* Migration guide (one-time, run locally):
   terraform init -migrate-state \
     -backend-config="bucket=YOUR_BUCKET" \
     -backend-config="region=us-east-1" \
     -backend-config="dynamodb_table=YOUR_LOCK_TABLE"
*/
