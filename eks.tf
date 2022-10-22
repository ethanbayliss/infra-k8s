locals {
  name = "django-for-impatient"
  tags = {
    Environment = var.env
    DeployedBy  = "Terraform"
    GithubRepo = "infra-k8s"
    GithubOrg  = "ethanbayliss"
  }
}
