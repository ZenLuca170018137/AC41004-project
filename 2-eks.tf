resource "aws_eks_cluster" "my-eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.master.arn
 vpc_config {
    subnet_ids = [
      aws_subnet.public-1.id,
      aws_subnet.public-2.id,
      aws_subnet.private-1.id,
      aws_subnet.private-2.id
    ]
}
  depends_on = [
aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
aws_vpc.vpc,
aws_subnet.public-1,
aws_subnet.public-2,
aws_subnet.private-1,
aws_subnet.private-2
  ]
  tags = {
    Name=var.cluster_name,
  }
}

/* output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
} */

resource "aws_cloudwatch_log_group" "eks_worker_nodes" {
  name              = "/aws/eks/worker-nodes"
  retention_in_days = 7
  tags = {
    Name="${var.cluster_name}-eks_worker_nodes",
  }
}

resource "aws_cloudwatch_log_stream" "eks_worker_nodes_stream" {
  name           = "worker-nodes-stream"
  log_group_name = aws_cloudwatch_log_group.eks_worker_nodes.name
  
}
