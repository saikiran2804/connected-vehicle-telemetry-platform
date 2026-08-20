# Inputs to this config. Defaults are set so you can run it with no extra flags.

variable "region" {
  description = "AWS region where the state bucket and lock table live."
  type        = string
  default     = "ap-south-1"
}

# S3 bucket names must be globally unique across ALL of AWS, so we suffix it
# with your account ID (663526348633) to guarantee uniqueness.
variable "state_bucket_name" {
  description = "Name of the S3 bucket that will store Terraform state."
  type        = string
  default     = "cvtp-tfstate-663526348633"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table used for state locking."
  type        = string
  default     = "cvtp-tf-lock"
}
