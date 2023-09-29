# Allocate an Elastic IP (EIP) for each private subnet to be used by the NAT gateway
resource "aws_eip" "my_eip" {
  for_each = aws_subnet.private_subnet
  domain   = "vpc"  # Indicates that the EIP is associated with a VPC
  
  tags = {
    Name = "my-eip-${each.key}"  # Naming convention for the EIPs
  }
}

# Create a NAT gateway in each private subnet to allow outbound internet access
resource "aws_nat_gateway" "my_nat_gateway" {
  for_each       = aws_subnet.private_subnet
  allocation_id  = aws_eip.my_eip[each.key].id  # Associate the EIP with the NAT gateway
  subnet_id      = each.value.id  # Specify the subnet where the NAT gateway will reside
  
  tags = {
    Name = "my-nat-gateway-${each.key}"  # Naming convention for the NAT gateways
  }
}

# Create a route table for each private subnet
resource "aws_route_table" "private_route_table" {
  for_each = aws_subnet.private_subnet
  vpc_id   = aws_vpc.vpc.id  # Associate the route table with the VPC
}

# Define a route in each private subnet's route table to route all traffic (0.0.0.0/0) to the NAT gateway
resource "aws_route" "private_route" {
  for_each              = aws_nat_gateway.my_nat_gateway
  route_table_id        = aws_route_table.private_route_table[each.key].id  # Specify the route table
  destination_cidr_block = "0.0.0.0/0"  # Route all traffic
  nat_gateway_id        = each.value.id  # Specify the NAT gateway as the target for routing
}

# Associate each private subnet with its corresponding route table
resource "aws_route_table_association" "my_rta" {
  for_each          = aws_subnet.private_subnet
  subnet_id         = each.value.id  # Specify the subnet
  route_table_id    = aws_route_table.private_route_table[each.key].id  # Specify the route table
}

output "route-table-id" {
  value = aws_route_table.private_route_table

  
}
output "ngw" {
  value = aws_nat_gateway.my_nat_gateway.id

  
}