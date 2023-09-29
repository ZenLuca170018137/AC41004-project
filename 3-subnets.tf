resource "aws_subnet" "private_subnet" {
  for_each = { for subnet in var.subnets : subnet.cidr_block => subnet }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
}

