# Pins the Terraform CLI and the AWS provider versions so every run is reproducible.
terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

# The AWS provider is the plugin that translates our code into AWS API calls.
# It reads credentials/region from the AWS CLI config we set up (aws configure).
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "connected-vehicle-telemetry-platform"
      ManagedBy = "terraform"
      Component = "tf-backend-bootstrap"
    }
  }
}
