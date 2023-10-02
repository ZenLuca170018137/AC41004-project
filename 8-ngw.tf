resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id  # Replace with your VPC ID or reference to your VPC resource

  tags = {
    Name = "my-internet-gateway"
  }
}

# Create a route table for public subnets to route outbound traffic through the Internet Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id  # Replace with your VPC ID or reference to your VPC resource

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the public route table with your public subnets
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public-1.id # Replace with your public subnet resource ID or reference
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public-2.id  # Replace with your public subnet resource ID or reference
  route_table_id = aws_route_table.public_route_table.id
}


///nat
resource "aws_eip" "nat_eip" {
 domain="vpc"
  tags = {
    Name = "NAT EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-1.id  # Assume you have a public subnet resource defined
  tags = {
    Name = "My NAT Gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id  # Assume you have a VPC resource defined

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private-1.id  # Assume you have a private subnet resource defined
  route_table_id = aws_route_table.private_route_table.id
}
