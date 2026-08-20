# A map of { repo_name = repository_url }. The push URL for docker/EKS.
output "repository_urls" {
  description = "Map of service name to its ECR repository URL."
  value       = { for name, repo in aws_ecr_repository.this : name => repo.repository_url }
}
