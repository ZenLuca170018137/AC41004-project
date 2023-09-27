resource "aws_alb" "Load-balancer" {

    name = "my-alb"
    internal = true
    security_groups = [
        aws_security_group.ingress-controller.id

    ]
    subnets = [
        aws_subnet.private-us-east-1a.id,
        aws_subnet.private-us-east-1b.id
    ]

  
    

    tags = {
        Name = "my-alb"
    }
  
}
//target groups
resource "aws_alb_target_group" "target-group" {
    name = "my-target-group"
   

    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    depends_on = [aws_alb.Load-balancer]
    tags = {
        Name = "my-target-group"
    }
}
//listener
resource "aws_alb_listener" "listener" {
    load_balancer_arn = aws_alb.Load-balancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_alb_target_group.target-group.arn
        type = "forward"
    }
    depends_on = [aws_alb_target_group.target-group]
}