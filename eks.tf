locals {
  name = "django-for-impatient"
  tags = {
    Environment = var.environment
    DeployedBy  = "Terraform"
    GithubRepo = "infra-k8s"
    GithubOrg  = "ethanbayliss"
  }
}
