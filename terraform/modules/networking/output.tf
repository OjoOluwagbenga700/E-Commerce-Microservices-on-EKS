output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnets

}

output "eks_cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_security_group.eks_cluster_sg.id
  
}
output "eks_node_sg_id" {
  description = "Security group ID for the EKS node group"
  value       = aws_security_group.eks_node_sg.id
  
}