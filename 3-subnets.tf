
resource "aws_subnet" "public-1" {

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[0].cidr_block 
  availability_zone = var.subnets[0].availability_zone

  tags = {
    name="public-1"
    Environment = "staging"
  }
}
resource "aws_subnet" "public-2" {
 
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[1].cidr_block 
  availability_zone = var.subnets[1].availability_zone

  tags = {
    name="public-2"
    Environment = "staging"

  }
}

resource "aws_subnet" "private-1" {

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[2].cidr_block 
  availability_zone = var.subnets[2].availability_zone

  tags = {
    name="private 1"
    Environment = "staging"
  }
}
resource "aws_subnet" "private-2" {

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[3].cidr_block 
  availability_zone = var.subnets[3].availability_zone

  tags = {
    name="priavte 2"
    Environment = "staging"
  }
}
