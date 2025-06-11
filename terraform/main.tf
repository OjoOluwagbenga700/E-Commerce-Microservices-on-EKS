



module "ecr" {
  source       = "./modules/ecr"
  aws_region   = var.aws_region
  project_name = var.project_name
  
}