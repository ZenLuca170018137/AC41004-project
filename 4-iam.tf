

//iam role for node groups
resource "aws_iam_role" "nodes" {
    name = "eks-nodes"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
  
    })
}
//iam policy for node groups
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.nodes.name
}
//cni policy
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
    policy_arn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role=aws_iam_role.nodes.name
  
}
//ec2 policy
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role=aws_iam_role.nodes.name
  
  
}


//IAM ROLE FOR AN EKS CLUSTER obtained from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster


data "aws_iam_policy_document" "cluster" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster-role" {
  name               = "eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.cluster.json
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster-role
}
