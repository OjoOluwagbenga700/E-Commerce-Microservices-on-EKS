variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "ecommerce-cluster"
  
}
variable "cluster_role_arn" {
  description = "The IAM role ARN for the EKS cluster"
  type        = string
}
variable "fargate_pod_execution_role_arn" {
  description = "The IAM role ARN for the EKS Fargate pod execution role"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "eks_cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}
variable "eks_node_sg_id" {
  description = "Security group ID for the EKS node group"
  type        = string
}
variable "service_ipv4_cidr" {
  description = "The CIDR block for the Kubernetes service network"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
  
}