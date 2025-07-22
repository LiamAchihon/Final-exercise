# Variables
locals {
  cluster_name = "my-eks-cluster"
 region = "us-east-1"

  
  tags = {
    Environment = "dev"
    Project     = "eks-terraform"
  }
}
