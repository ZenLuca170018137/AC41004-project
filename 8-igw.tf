resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "igw"
    }
  
}

resource "aws_route" "internet_gateway-a" {
  route_table_id            = aws_subnet.private-us-east-1a.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}
 resource "aws_route" "internet_gateway-b" {
    route_table_id            = aws_subnet.private-us-east-1b.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.igw.id
   
 }