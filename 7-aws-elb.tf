# Application Load Balancer (ALB) Configuration
resource "aws_alb" "load_balancer" {
  name                       = "my-alb"  # Name of the ALB
  internal                   = true  # Specifies that the ALB is internal (not exposed to the internet)
  subnets                    = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
   
  ]  #
  enable_deletion_protection = false  # Disables deletion protection for the ALB
  security_groups            = [  # Security groups to be associated with the ALB
    aws_security_group.eks_control_plane_sg.id,
    aws_security_group.worker_node_sg.id
  ]
  tags                       = { Name = "my-alb" }  # Tags for the ALB
}

# ALB Target Group Configuration
resource "aws_alb_target_group" "target_group" {
  name     = "my-target-group"  # Name of the target group
  port     = 80  # Port on which targets receive traffic
  protocol = "HTTP"  # Protocol used to route traffic to targets
  vpc_id   = aws_vpc.vpc.id  # VPC ID where the target group is located

  # Health check settings to monitor the health of the targets
  health_check {
    enabled             = true  # Enables health check
    interval            = 30  # Interval between health checks
    path                = "/"  # URL path to perform health checks
    port                = "traffic-port"  # Port to perform health check (traffic-port indicates the port on which each target receives traffic)
    timeout             = 5  # Timeout for each health check
    healthy_threshold   = 3  # Number of consecutive successful health checks required to consider a target healthy
    unhealthy_threshold = 3  # Number of consecutive failed health checks required to consider a target unhealthy
  }

  tags = {
    Name = "my-target-group"  # Tags for the target group
  }
}

# ALB Listener Configuration
resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.load_balancer.arn  # ARN of the ALB to which the listener is attached
  port              = 80  # Port on which the listener receives traffic
  protocol          = "HTTP"  # Protocol for routing traffic

  # Default action to take if no route matches
  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn  # ARN of the target group to forward traffic to
    type             = "forward"  # Action type (forward traffic to the specified target group)
  }
}


