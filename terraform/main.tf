module "networking" {
  source          = "./modules/networking"
  project_name    = var.project_name
  cluster_name    = var.cluster_name
  azs             = var.azs
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}



module "ecr" {
  source       = "./modules/ecr"
  aws_region   = var.aws_region
  project_name = var.project_name

}