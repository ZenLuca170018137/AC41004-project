resource "aws_nat_gateway" "private-ngw-1" {
  connectivity_type = "private"
    subnet_id = aws_subnet.private-us-east-1a.id
    tags = {
        Name = "private-ngw"
    }

  
}
resource "aws_nat_gateway" "private-ngw-2" {
  connectivity_type = "private"
    subnet_id = aws_subnet.private-us-east-1b.id
    tags = {
        Name = "private-ngw-2"
    }

  
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "10.0.0.0/19"
    nat_gateway_id = aws_nat_gateway.private-ngw-1.id
    }
    route {
    cidr_block ="10.0.32.0/19"
    nat_gateway_id = aws_nat_gateway.private-ngw-2.id
    }
    tags = {
        Name = "private-rt"
    }
}

//route table assosiation
resource "aws_route_table_association" "private-rt-assosiation" {
    subnet_id = aws_subnet.private-us-east-1a.id
    route_table_id = aws_route_table.private-rt.id
}