module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs              = ["${var.AWS_DEFAULT_REGION}a", "${var.AWS_DEFAULT_REGION}b", "${var.AWS_DEFAULT_REGION}c"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  # Manage so we can name
  manage_default_network_acl    = true
  manage_default_route_table    = true
  manage_default_security_group = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  default_route_table_tags      = { Name = "${local.name}-default" }
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_subnet_tags = {
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"     = 1
  }
}
