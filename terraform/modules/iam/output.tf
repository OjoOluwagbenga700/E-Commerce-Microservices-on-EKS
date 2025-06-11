output "fargate_pod_execution_role_arn" {
  description = "ARN of the EKS Fargate pod execution role"
  value       = aws_iam_role.eks_fargate_pod_execution_role.arn
  
}
output "cluster_role_arn" {
  description = "ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.arn
}