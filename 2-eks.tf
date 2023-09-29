module "eks" {
  source          = "terraform-aws-modules/eks/aws"  # Specify the source for the EKS module
  cluster_name    = var.cluster_name                  # Define the name of the EKS cluster
  cluster_version = "1.28"                            # Define the version of EKS to use
  subnet_ids      = [for subnet in aws_subnet.private_subnet : subnet.id]  # List of subnets where the EKS cluster and nodes will be deployed

  vpc_id = aws_vpc.vpc.id  # Specify the VPC ID where the EKS cluster will be deployed

  # Defaults for EKS Managed Node Groups
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
  

    instance_types = ["t2.micro"]

    # Disable attaching the primary security group of the cluster to nodes
    attach_cluster_primary_security_group = false  

  }

  # Configuration for EKS Managed Node Groups
  eks_managed_node_groups = {
    ng1 = {
      desired_capacity = 2  # Desired number of worker nodes in the node group
      max_capacity     = 2  # Maximum number of worker nodes in the node group
      min_capacity     = 1  # Minimum number of worker nodes in the node group
    
        instance_types = ["t2.micro"]  # List of instance types to use for the worker nodes

      capacity_type    = "ON_DEMAND"  # Specify the capacity type as on-demand

      tags = {
        "Name" = "ng1"  # Name tag for the resources in this node group
      }
    }
  }
}

# Output the endpoint of the EKS cluster
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

# Output the security group ID of the EKS cluster
output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
