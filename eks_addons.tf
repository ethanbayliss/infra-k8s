module "eks_blueprints_kubernetes_addons" {
  source = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints.git//modules/kubernetes-addons?ref=ac614b5a079055f9b18926597c55e8c6c9425263"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version

  # Wait on the `kube-system` profile before provisioning addons
  data_plane_wait_arn = module.eks_blueprints.fargate_profiles["kube_system"].eks_fargate_profile_arn

  #https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/ac614b5a079055f9b18926597c55e8c6c9425263/modules/kubernetes-addons/fargate-fluentbit
  enable_fargate_fluentbit = true

  #https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/ac614b5a079055f9b18926597c55e8c6c9425263/modules/kubernetes-addons/aws-vpc-cni
  enable_amazon_eks_vpc_cni = true
  amazon_eks_vpc_cni_config = {
    most_recent = true
  }

  #https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/ac614b5a079055f9b18926597c55e8c6c9425263/modules/kubernetes-addons/aws-kube-proxy
  enable_amazon_eks_kube_proxy = true
  amazon_eks_kube_proxy_config = {
    most_recent = true
  }

  enable_self_managed_coredns       = true
  remove_default_coredns_deployment = true
  self_managed_coredns_helm_config  = {
    # Sets the correct annotations to ensure the Fargate provisioner is used and not the EC2 provisioner
    compute_type       = "fargate"
    kubernetes_version = module.eks_blueprints.eks_cluster_version
  }

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller_helm_config = {
    set_values = [
      {
        name  = "vpcId"
        value = module.vpc.vpc_id
      },
      {
        name  = "podDisruptionBudget.maxUnavailable"
        value = 1
      },
    ]
  }

  #https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/ac614b5a079055f9b18926597c55e8c6c9425263/docs/add-ons/kubernetes-dashboard.md
  enable_kubernetes_dashboard      = true
  kubernetes_dashboard_helm_config = {
    namespace        = "default"
    create_namespace = false
  }

  tags = local.tags
}
