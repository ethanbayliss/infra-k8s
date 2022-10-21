data "aws_caller_identity" "default" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.36.0"
    }
  }

  backend "s3" {
    bucket = var.tfstate_bucket
    key    = path.root
    region = var.AWS_DEFAULT_REGION
  }
}

provider "aws" {
  region     = var.AWS_DEFAULT_REGION
}

# provider "kubernetes" {
#   host                   = module.eks_blueprints.eks_cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks_blueprints.eks_cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
#     token                  = data.aws_eks_cluster_auth.this.token
#   }
# }
