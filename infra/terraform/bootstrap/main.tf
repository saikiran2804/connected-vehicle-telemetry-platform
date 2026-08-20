# ---------------------------------------------------------------------------
# S3 bucket that will hold Terraform state files for the whole project.
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name
}

# Keep every version of the state file. If state is ever corrupted or a bad
# apply happens, we can roll back to a previous version.
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt the state at rest. State can contain sensitive values, so this is
# a security best practice (and cheap/free with SSE-S3).
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block ALL public access to the bucket. State must never be internet-readable.
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------------------------
# DynamoDB table used ONLY as a lock, so two `terraform apply` runs can't
# corrupt the state at the same time. Terraform expects a primary key
# named exactly "LockID". PAY_PER_REQUEST = on-demand billing = free-tier
# friendly (you pay per request, and a lock is a few tiny requests).
# ---------------------------------------------------------------------------
resource "aws_dynamodb_table" "tf_lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
