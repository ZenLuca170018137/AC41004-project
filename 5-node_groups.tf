resource "aws_eks_node_group" "general" {
cluster_name = "my-eks"
node_group_name = "general"
node_role_arn = aws_iam_role.node-groups.arn
subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
]
capacity_type = "SPOT"
instance_types = ["t3.micro"]
scaling_config{
    desired_size = 1
    max_size = 2
    min_size = 1
}
depends_on = [ aws_iam_role_policy_attachment.node-groups-AmazonEKS_CNI_Policy,
aws_iam_role_policy_attachment.node-groups-AmazonEKSWorkerNodePolicy,
aws_iam_role_policy_attachment.node-groups-AmazonEC2ContainerRegistryReadOnly ]
  tags = {
    Name="general"
  }
  
}

/*
resource "aws_eks_node_group" "spot" {
cluster_name = "my-eks"
node_group_name = "spot"
node_role_arn = aws_iam_role.node-groups.arn
subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
]
capacity_type = "SPOT"
instance_types = ["t2.micro"]
scaling_config{
    desired_size = 1
    max_size = 2
    min_size = 1
}
depends_on = [ aws_iam_role_policy_attachment.node-groups-AmazonEKS_CNI_Policy,
aws_iam_role_policy_attachment.node-groups-AmazonEKSWorkerNodePolicy,
aws_iam_role_policy_attachment.node-groups-AmazonEC2ContainerRegistryReadOnly ]
  tags = {
    Name="spot"
  }
  
}
*/
