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

 //namespace for kurbanetes
resource "kubernetes_namespace" "devops-namespace" {
  metadata {
    name = "${var.namespaces[0]}"
  }
}
//classic load balancer configuration to handle traffic
resource "kubernetes_service" "classic-load-balancer" {
  metadata {
    name      = "classic-load-balancer"
    namespace ="${var.namespaces[0]}"
    labels = {
      app = "apache_app-load-balancer"
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "elb"
    }
  }

  spec {
    selector = {
      app = "apache_app"
    }

    port {
      port        = 80//exposed on port 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
  
} 

