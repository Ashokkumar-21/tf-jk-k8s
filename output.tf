output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for accessing the EKS cluster"
  value       = module.eks.kubeconfig
  sensitive   = true
}

output "ecr_repo_url" {
  value = aws_ecr_repository.static_site_repo.repository_url
}