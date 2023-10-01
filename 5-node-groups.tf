resource "aws_eks_node_group" "general" {
cluster_name = var.cluster_name
    node_role_arn = aws_iam_role.worker.arn
     node_group_name = "general"
    subnet_ids = [

        aws_subnet.private-1.id,
        aws_subnet.private-2.id
    ]

 
    
    scaling_config {
        desired_size = var.capacity[0].desired_size
        max_size     = var.capacity[0].max_size
        min_size     = var.capacity[0].min_size
    }
    update_config {
        max_unavailable = "1"
    }
    ami_type = "AL2_x86_64"
    capacity_type = var.capacity[0].capacity_type
    instance_types = var.capacity[0].instance_types
    disk_size = 20
    labels = {
        "Environment" = "staging"
    }

    depends_on = [ aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly]

  tags={
    Name = "general"
    Environment = "staging"
  }
}