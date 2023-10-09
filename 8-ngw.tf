
#  Internet Gateway resource for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "my-internet-gateway"
  }
}

# a route table for public subnets to route outbound traffic through the Internet Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id  
  # Route specification to direct outbound traffic through the Internet Gateway

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

// associate public route table with the public subnet
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public-1.id 
  route_table_id = aws_route_table.public_route_table.id
}
// associate public route table with a public subnet
resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public-2.id  
  route_table_id = aws_route_table.public_route_table.id
}


///resource to create elastic IP for the nodes in the cluster
resource "aws_eip" "nat_eip" {
 domain="vpc"
  tags = {
    Name = "NAT EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-1.id 
  tags = {
    Name = "My NAT Gateway"
  }
}
// resource to create a nat gateway that allows for better networking within the cluster
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id //vpc

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private Route Table"
  }
}
//private route table to handle traffic within the cluster
resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private-1.id 
  route_table_id = aws_route_table.private_route_table.id
}
//setting up cloud watch alarms which is triggered when more than one port allocation errors occurs within 5 minutes
resource "aws_cloudwatch_metric_alarm" "nat_gateway_error_port_allocation" {
  alarm_name          = "NatGatewayErrorPortAllocation"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NATGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = "3"   
  alarm_description   = "Triggered when there are more than 1 port allocation errors within 5 minutes."
  alarm_actions       = [aws_sns_topic.issue.arn] 
  dimensions = {
    NatGatewayId = aws_nat_gateway.nat_gateway.id
  }
}
//SNS topic resource that the alarm can be associated with
resource "aws_sns_topic" "issue" {
  name = "nat-gateway-error-alert"
}
//sns topic needs subscribers so that it can relay any issues to  the releveant user
resource "aws_sns_topic_subscription" "ngw-subscription" {
  topic_arn = aws_sns_topic.issue.arn
  
  protocol  = "email"
  endpoint  = "dev-email@gmail.com"
}