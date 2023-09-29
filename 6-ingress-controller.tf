resource "aws_security_group" "eks_control_plane_sg" {
  name        = "eks-control-plane-sg"
  description = "Security group for the EKS control plane"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name        = "eks-control-plane-sg"
    Environment = "staging" 
  }
}

resource "aws_security_group" "worker_node_sg" {
  name        = "eks-worker-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name        = "eks-worker-node-sg"
    Environment = "staging" 
  }
}

resource "aws_security_group_rule" "control_plane_to_worker" {
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
}

resource "aws_security_group_rule" "worker_to_control_plane" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.worker_node_sg.id
}

resource "aws_security_group_rule" "control_plane_ingress" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "control_plane_egress" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_ssh_ingress" {
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_egress" {
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
