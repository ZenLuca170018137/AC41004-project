resource "aws_eks_node_group" "node-groups" {
cluster_name = "my-eks"
node_group_name = "eks_self_managed_node_group"
node_role_arn = aws_iam_role.nodes.arn
subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
]
capacity_type = "SPOT"
instance_types = ["t3.micro"]
scaling_config {
  desired_size = 1
  max_size     = 2
  min_size     = 1
}
update_config {
  max_unavailable = 1
}
depends_on = [ aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly ]
  tags = {
    Name="eks_self_managed_node_group"
  }
  
}
