module "networking" {
  source          = "./modules/networking"
  project_name    = var.project_name
  cluster_name    = var.cluster_name
  azs             = var.azs
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  bucket_name  = var.bucket_name

}
module "dynamodb" {
  source       = "./modules/dynamodb"
  products_table = var.products_table
  orders_table   = var.orders_table
  tickets_table  = var.tickets_table
  
}

module "ecr" {
  source       = "./modules/ecr"
  aws_region   = var.aws_region
  project_name = var.project_name

}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name

}
module "eks" {
  source                         = "./modules/eks"
  cluster_name                   = var.cluster_name
  cluster_role_arn               = module.iam.cluster_role_arn
  fargate_pod_execution_role_arn = module.iam.fargate_pod_execution_role_arn
  service_ipv4_cidr              = var.service_ipv4_cidr
  tags                           = var.tags
  private_subnet_ids             = module.networking.private_subnet_ids
  eks_cluster_sg_id              = module.networking.eks_cluster_sg_id
  eks_node_sg_id                 = module.networking.eks_node_sg_id
}