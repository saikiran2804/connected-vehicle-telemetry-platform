output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "API server endpoint (kubectl talks to this)."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA."
  value       = aws_iam_openid_connect_provider.oidc.arn
}

output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}
