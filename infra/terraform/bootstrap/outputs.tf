# After apply, Terraform prints these. We'll copy them into the backend
# config of the main infrastructure (VPC/EKS) in the next step.

output "state_bucket_name" {
  description = "Use this as the S3 backend bucket for the main config."
  value       = aws_s3_bucket.tf_state.id
}

output "lock_table_name" {
  description = "Use this as the DynamoDB lock table for the main config."
  value       = aws_dynamodb_table.tf_lock.name
}

output "region" {
  value = var.region
}
