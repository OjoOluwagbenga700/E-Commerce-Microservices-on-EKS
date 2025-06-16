locals {
  services = {
    frontend = "${path.module}/../../../cloudmart/frontend"
    backend  = "${path.module}/../../../cloudmart/backend"
  }
}
# ECR Repositories
resource "aws_ecr_repository" "ecr_repo" {
  for_each = local.services
  name     = "${var.project_name}-${each.key}"
  force_delete = true
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project_name
    Service = each.key
  }
}


# Create Docker image for frontend and backend
resource "docker_image" "image" {
  for_each = local.services
  name = "${aws_ecr_repository.ecr_repo[each.key].repository_url}:Latest"
  build {
    context    = each.value
    dockerfile = "Dockerfile"
  }
}


# Push frontend docker image to ECR repo
resource "docker_registry_image" "image_push" {
  for_each = local.services
  name       = docker_image.image[each.key].name
  depends_on = [
    aws_ecr_repository.ecr_repo,
    docker_image.image]
  
}


resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  for_each   = local.services
  repository = aws_ecr_repository.ecr_repo[each.key].name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 2 images"
        selection = {
          tagStatus   = "tagged"
          countType   = "imageCountMoreThan"
          countNumber = 2
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
