resource "aws_eks_node_group" "general" {
cluster_name = var.cluster_name
    node_role_arn = aws_iam_role.worker.arn
     node_group_name = "general"
    subnet_ids = [

        aws_subnet.private-1.id,
        aws_subnet.private-2.id
    ]
    
    scaling_config {
        desired_size = var.capacity.desired_size
        max_size     = var.capacity.max_size
        min_size     = var.capacity.min_size
    }
    
    update_config {
        max_unavailable = "1"
    }
  
    ami_type = "AL2_x86_64"

    capacity_type = var.capacity.capacity_type
    instance_types = var.capacity.instance_types
   
    disk_size = 40
    labels = {
        "Environment" = "staging"
    }

    depends_on = [ aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
     aws_eks_cluster.my-eks,
     aws_vpc.vpc,
     aws_subnet.private-1,
     aws_subnet.private-2,
kubernetes_config_map.aws_auth]

  tags = {
    Name = "general"
    Environment = "staging"
  }
}
