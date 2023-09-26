

resource "aws_eks_cluster" "my-eks" {
name="my-eks"

    
    role_arn =aws_iam_role.example.arn
     vpc_config {
        subnet_ids =[
            aws_subnet.private-us-east-1a.id,
            aws_subnet.private-us-east-1b.id
        ]
        
      }
      depends_on = [ aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceControlle ]
   
    tags = {
      name="my-eks"
    }
}