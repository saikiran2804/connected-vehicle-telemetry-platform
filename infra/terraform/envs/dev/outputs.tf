# Surface the module's outputs at the environment level so we (and later
# the EKS module) can read the VPC and subnet IDs.

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "ecr_repository_urls" {
  description = "ECR repo URLs to push images to."
  value       = module.ecr.repository_urls
}
