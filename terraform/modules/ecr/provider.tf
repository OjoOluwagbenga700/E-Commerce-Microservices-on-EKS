# Docker provider configuration for ECR authentication
# Configure required providers for AWS and Docker to manage infrastructure
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }

  }

}

# Configure AWS provider with region specified in variables
provider "aws" {
  region = var.aws_region
}


provider "docker" {
  registry_auth {

    # ECR registry address using AWS account ID and region
    address = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    # ECR authentication credentials from token
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password

  }
}