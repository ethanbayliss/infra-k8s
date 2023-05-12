module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  name = var.name
  cidr = "10.0.0.0/16"

  azs              = ["${var.AWS_DEFAULT_REGION}a", "${var.AWS_DEFAULT_REGION}b", "${var.AWS_DEFAULT_REGION}c"]
  private_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets   = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
  database_subnets = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]

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
  default_network_acl_tags      = { Name = "${var.name}-default" }
  default_route_table_tags      = { Name = "${var.name}-default" }
  default_security_group_tags   = { Name = "${var.name}-default" }

  public_subnet_tags = {
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"     = 1
  }
}
