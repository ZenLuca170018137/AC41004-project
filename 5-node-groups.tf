resource "aws_eks_node_group" "general" {
cluster_name = var.cluster_name
    node_role_arn = aws_iam_role.worker.arn
     node_group_name = "general"
    subnet_ids = [

        aws_subnet.private-1.id,
        aws_subnet.private-2.id
    ]

 
    
    scaling_config {
        desired_size = 1
        max_size     = 4
        min_size     = 1
    }
    
    update_config {
        max_unavailable = "1"
    }
  
    ami_type = "AL2_x86_64"

    capacity_type = "ON_DEMAND"
    instance_types = ["t2.small"]
   
    disk_size = 20
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

  tags={
    Name = "general"
    Environment = "staging"
  }
}
