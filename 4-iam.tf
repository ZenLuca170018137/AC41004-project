//iam role for nodes
resource "aws_iam_role" "node" {
    name = "node-role"
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
//iam instance profile
resource "aws_iam_instance_profile" "node" {
    name = "eks-nodes"
    role = aws_iam_role.node.name
}


//iam role for node groups
resource "aws_iam_role" "node-groups" {
    name = "eks-node-groups"
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
resource "aws_iam_role_policy_attachment" "node-groups-AmazonEKSWorkerNodePolicy" {
  
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node-groups.name
}
//cni policy
resource "aws_iam_role_policy_attachment" "node-groups-AmazonEKS_CNI_Policy" {
    policy_arn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role=aws_iam_role.node-groups.name
  
}
//ec2 policy
resource "aws_iam_role_policy_attachment" "node-groups-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role=aws_iam_role.node-groups.name
  
  
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
  role       = aws_iam_role.cluster-role.name
}


//TODO: IAM oidc
