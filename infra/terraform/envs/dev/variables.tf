variable "region" {
  description = "AWS region for the dev environment."
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name, used in tags and resource prefixes."
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Short project prefix for resource names."
  type        = string
  default     = "cvtp"
}
