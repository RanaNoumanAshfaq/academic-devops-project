# =========================================================================
#  ACADEMIC PROJECT: MULTI-CLOUD INFRASTRUCTURE MANAGER
# =========================================================================

# -------------------------------------------------------------------------
#  AWS INFRASTRUCTURE
# -------------------------------------------------------------------------

# 1. AWS Networking (VPC, Public/Private Subnets, Gateways)
module "aws_network" {
  source       = "./modules/aws-network"
  vpc_cidr     = var.aws_vpc_cidr
  project_name = var.project_name
}

# 2. AWS EKS Cluster (Kubernetes Control Plane & Worker Nodes)
module "aws_eks" {
  source          = "./modules/aws-eks"
  project_name    = var.project_name
  
  # Dependencies: Needs Network details to know where to deploy
  vpc_id          = module.aws_network.vpc_id
  public_subnets  = module.aws_network.public_subnets
  private_subnets = module.aws_network.private_subnets 
}

# 3. AWS Object Storage (S3 Bucket for file storage)
module "aws_s3" {
  source       = "./modules/aws-s3"
  project_name = var.project_name
}

# 4. AWS Relational Database (RDS MySQL in Private Subnet)
module "aws_rds" {
  source          = "./modules/aws-rds"
  project_name    = var.project_name
  
  # Dependencies: Needs Network details for security groups and placement
  vpc_id          = module.aws_network.vpc_id
  private_subnets = module.aws_network.private_subnets
}


# -------------------------------------------------------------------------
#  AZURE INFRASTRUCTURE (Commented out until AWS is stable)
# -------------------------------------------------------------------------
# module "azure_aks" {
#   source       = "./modules/azure-aks"
#   project_name = var.project_name
#   # location   = var.azure_location
# }


# -------------------------------------------------------------------------
#  GCP INFRASTRUCTURE (Commented out until AWS is stable)
# -------------------------------------------------------------------------
# module "gcp_gke" {
#   source         = "./modules/gcp-gke"
#   project_name   = var.project_name
#   region         = var.gcp_region
#   gcp_project_id = var.gcp_project_id
# }