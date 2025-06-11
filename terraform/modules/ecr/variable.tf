variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}
variable "project_name" {
  description = "The name of the project for naming resources"
  type        = string
    default     = "e-commerce"
}