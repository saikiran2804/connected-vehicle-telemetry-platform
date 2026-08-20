# Pins versions and configures the AWS provider for the dev environment.
terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.region

  # Applied to every resource automatically — makes cost tracking easy.
  default_tags {
    tags = {
      Project     = "connected-vehicle-telemetry-platform"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
