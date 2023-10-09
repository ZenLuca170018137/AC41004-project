# IAM Role for EKS Master 
resource "aws_iam_role" "master" {
  name = "ed-eks-master"

  # Trust relationship to allow EKS service to assume this role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach required policies to the EKS Master IAM Role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.master.name
}

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "worker" {
  name = "ed-eks-worker"

  # Trust relationship to allow EC2 instances to assume this role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach required policies to the EKS Worker Nodes IAM Role
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "x-ray" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = aws_iam_role.worker.name
}
//role attatchment for s3
resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.worker.name
}

# OpenID Connect (OIDC) provider for the EKS cluster
resource "aws_iam_openid_connect_provider" "default_OIDC" {
  url = "https://oidc.eks.us-east-1.amazonaws.com/id/${aws_eks_cluster.my-eks.id}"

  client_id_list = [
      "sts.amazonaws.com"
   ]

  thumbprint_list = ["aaa68bb211d468db8a8a19561ccba2e4043dcc80"]
}

# Output the OIDC URL
output "oidc" {
  value = aws_iam_openid_connect_provider.default_OIDC.url
}

# Kubernetes ConfigMap for AWS authentication with EKS
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  # Role mappings for Master and Worker roles
  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.master.arn}
  username: ${aws_iam_role.master.name}
  groups:
    - system:masters
- rolearn: ${aws_iam_role.worker.arn}
  username: ${aws_iam_role.worker.name}
  groups:
    - system:bootstrappers
    - aws-node
EOF
  }

  # Ensure the EKS cluster is created before mapping the roles
  depends_on = [
    aws_eks_cluster.my-eks,
  ]
}

# Authentication data for the EKS cluster
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.my-eks.name
}

# Kubernetes provider configuration for EKS authentication
provider "kubernetes" {
  host                   = aws_eks_cluster.my-eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my-eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}