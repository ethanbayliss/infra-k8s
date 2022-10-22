locals {
  name = "django-for-impatient"
  tags = {
    Environment = var.env
    DeployedBy  = "Terraform"
    GithubRepo = "infra-k8s"
    GithubOrg  = "ethanbayliss"
  }
}

module "eks_blueprints" {
  source = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints.git?ref=v4.13.1"

  cluster_name    = local.name
  cluster_version = var.cluster_version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  map_roles = [
    {
      #rolearn must be modified to not include the "/aws-reserved/sso.amazonaws.com/ap-southeast-2" part
      rolearn  = var.admin_role_arn
      username = "ops-role"
      groups   = ["system:masters"]
    }
  ]

  # https://github.com/aws-ia/terraform-aws-eks-blueprints/issues/485
  # https://github.com/aws-ia/terraform-aws-eks-blueprints/issues/494
  cluster_kms_key_additional_admin_arns = [data.aws_caller_identity.current.arn]

  fargate_profiles = {
    # Providing compute for default namespace
    default = {
      fargate_profile_name = "default"
      fargate_profile_namespaces = [
        {
          namespace = "*"
        },
      ]
      subnet_ids = module.vpc.private_subnets
    }
  }

  tags = local.tags
}
