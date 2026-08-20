# =====================================================================
# REMOTE STATE BACKEND
# This is what connects to the S3 bucket + DynamoDB table you created in
# bootstrap/. Terraform stores THIS environment's state in S3 (shared,
# versioned, encrypted) and uses DynamoDB to lock it during changes.
#
# NOTE: backend blocks CANNOT use variables — the values must be literal.
# That's a deliberate Terraform rule (state must be locatable before vars load).
# =====================================================================
terraform {
  backend "s3" {
    bucket         = "cvtp-tfstate-663526348633"
    key            = "dev/infra.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "cvtp-tf-lock"
    encrypt        = true
  }
}
