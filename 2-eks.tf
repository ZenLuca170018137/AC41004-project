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
  ]
}

/* output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
} */