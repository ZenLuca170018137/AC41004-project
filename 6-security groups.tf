# EKS Control Plane Security Group
resource "aws_security_group" "eks_control_plane_sg" {
  # Name and description of the security group
  name        = "eks-control-plane-sg"
  description = "Security group for the EKS control plane"

  # VPC in which the security group is to be created
  vpc_id      = aws_vpc.vpc.id

  # Tags for the security group
  tags = {
    Name        = "eks-control-plane-sg"
    Environment = "staging" 
  }
}

# EKS Worker Nodes Security Group
resource "aws_security_group" "worker_node_sg" {
  # Name and description of the security group
  name        = "eks-worker-node-sg"
  description = "Security group for EKS worker nodes"

  # VPC in which the security group is to be created
  vpc_id      = aws_vpc.vpc.id

  # Tags for the security group
  tags = {
    Name        = "eks-worker-node-sg"
    Environment = "staging" 
  }
}

# Rule to allow traffic from Control Plane to Worker Nodes
resource "aws_security_group_rule" "control_plane_to_worker" {
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
}

# Rule to allow traffic from Worker Nodes to Control Plane
resource "aws_security_group_rule" "worker_to_control_plane" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.worker_node_sg.id
}

# Rule to allow HTTPS (port 443) traffic ingress to the Control Plane
resource "aws_security_group_rule" "control_plane_ingress" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Rule to allow all egress traffic from the Control Plane
resource "aws_security_group_rule" "control_plane_egress" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Rule to allow SSH (port 22) traffic ingress to the Worker Nodes
resource "aws_security_group_rule" "worker_ssh_ingress" {
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Rule to allow all egress traffic from the Worker Nodes
resource "aws_security_group_rule" "worker_egress" {
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
