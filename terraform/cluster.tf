locals {
  cluster_name = "Kubernetes"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_version = "1.19"
  cluster_name    = local.cluster_name
  vpc_id          = aws_vpc.vpc.id
  subnets         = [         aws_subnet.private_1.id,
                              aws_subnet.private_2.id,
                              aws_subnet.private_3.id
                    ]
  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3

      instance_types = [var.worker-instance-type]
    }
  }

  #map_users         = var.map_users
  #map_roles         = var.map_roles
  # Makes specifying IAM users or roles with cluster access easier
  manage_aws_auth       = true

  write_kubeconfig   = true
  enable_irsa = true
}
