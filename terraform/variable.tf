variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

}
variable "bucket_name" {
  description = "The name of the S3 bucket for storing application data"
  type        = string
  default     = "app-bucket"
}

variable "products_table" {
  description = "The name of the DynamoDB table for products"
  type        = string
  default     = "cloudmart-products"

}
variable "orders_table" {
  description = "The name of the DynamoDB table for orders"
  type        = string
  default     = "cloudmart-orders"

}
variable "tickets_table" {
  description = "The name of the DynamoDB table for tickets"
  type        = string
  default     = "cloudmart-tickets"

}
variable "project_name" {
  description = "The name of the project for naming resources"
  type        = string
  default     = "cloudmart"
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "cloudmart-cluster"
}
variable "azs" {
  description = "List of availability zones to use for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
variable "service_ipv4_cidr" {
  description = "The CIDR block for the Kubernetes service network"
  type        = string
  default     = "10.100.0.0/16"
}
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Project = "cloudmart"
    Owner   = "terraform"
  }
}