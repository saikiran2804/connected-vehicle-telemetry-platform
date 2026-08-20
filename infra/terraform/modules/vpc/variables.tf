# Inputs the module accepts. The environment (envs/dev) supplies these.

variable "name" {
  description = "Name prefix applied to all resources (e.g. cvtp-dev)."
  type        = string
}

variable "cidr_block" {
  description = "The overall IP range for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "How many availability zones (and subnet pairs) to create."
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "IP ranges for the public subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "IP ranges for the private subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "tags" {
  description = "Extra tags applied to every resource."
  type        = map(string)
  default     = {}
}
