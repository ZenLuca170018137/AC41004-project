/*
//create security group
resource "aws_security_group" "ingress_controller" {
    description = "controls all "
    vpc_id = aws_vpc.vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  //security_group_id =""
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/8"]
}

tags={
    Name="ingress_controller"
}
}
module "alb-ingress-controller" {
  source  = "campaand/alb-ingress-controller/aws"
  version = "2.0.0"
  # insert the 1 required variable here
     cluster_name = var.cluster_name
 
}
   output "cluster_name_debug" {
  value = var.cluster_name
}
*/