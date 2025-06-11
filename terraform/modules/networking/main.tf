# Create VPC using terraform-aws-modules/vpc/aws module
module "networking" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  # VPC configuration
  name                 = "${var.project_name}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = var.azs
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_nat_gateway   = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                   = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# Security group for EKS tasks
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = module.networking.vpc_id

 # Allow inbound communication from node group
  ingress {
    description     = "Allow nodes to communicate with control plane"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.project_name}-eks-cluster-sg"
    Project     = var.project_name
    Kubernetes  = "cluster"
  }
}


# Security group for EKS Node Group
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.project_name}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.networking.vpc_id

  # Allow nodes to communicate with each other
  ingress {
    description     = "Node to node communication"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    self            = true
  }


   # Allow nodes to receive traffic from the control plane
  ingress {
    description     = "Allow control plane to communicate with nodes"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-eks-node-sg"
    Project     = var.project_name
    Kubernetes  = "node"
  }
}

resource "aws_security_group_rule" "cluster_to_node" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  description              = "Allow control plane to communicate with nodes"
}

resource "aws_security_group_rule" "node_to_cluster" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_node_sg.id
  description              = "Allow nodes to communicate with control plane"
}