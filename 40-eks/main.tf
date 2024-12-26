resource "aws_key_pair" "eks" {
  key_name = "eks"
#   public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF6xqVyunYvdxro7hU2VUQc65wGcepoGT0DcGNtEhFH5 amarn@AMAR"
  public_key = file("C:\\Users\\amarn\\.ssh\\eks.pub")
  
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "expense"
  cluster_version = "1.31"

 
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  create_cluster_security_group = false
  cluster_security_group_id = local.eks_control_plane_sg_id

  create_node_security_group = false
  node_security_group_id = local.node_sg_id

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = data.aws_ssm_parameter.vpc.value
  subnet_ids               = local.private_subnet
  control_plane_subnet_ids = local.private_subnet

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups

      min_size     = 2
      max_size     = 10
      desired_size = 2

      iam_role_additional_policies={
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonLoadBalancerPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"

      }
      key_name = aws_key_pair.eks.key_name
    }

    # green = {
    #   # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups

    #   min_size     = 2
    #   max_size     = 10
    #   desired_size = 2

    #   iam_role_additional_policies={
    #     AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    #     AmazonLoadBalancerPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"

    #   }
    #   key_name = aws_key_pair.eks.key_name
    # }
    
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}