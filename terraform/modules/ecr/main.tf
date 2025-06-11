
locals {
  services = {
    orders        = "${path.module}/../../../orders-service"
    payments      = "${path.module}/../../../payments-service"
    users         = "${path.module}/../../../users-service"
    products      = "${path.module}/../../../products-service"
    carts         = "${path.module}/../../../carts-service"
    auth          = "${path.module}/../../../auth-service"
    notifications = "${path.module}/../../../notifications-service"
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  for_each             = local.services
  name                 = "${var.project_name}-${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "docker_image" "image" {
  for_each = local.services
  name     = "${aws_ecr_repository.ecr_repo[each.key].repository_url}:latest"
  build {
    context    = each.value
    dockerfile = "Dockerfile"
  }
}

resource "docker_registry_image" "image" {
  for_each = local.services
  name     = docker_image.image[each.key].name
  depends_on = [
    aws_ecr_repository.ecr_repo,
    docker_image.image
  ]
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
