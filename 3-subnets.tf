//AWS recuires that for a cluster network to work efficiently 2-4 subnets are needed
// the 4 subnets can be public or private
//public subnets are subnets attached to the internet gateway


resource "aws_subnet" "public-1" {

  vpc_id     = aws_vpc.vpc.id//vpc id 
  cidr_block = var.subnets[0].cidr_block // cidr blovk to be attached to the subnet declaed in the config file
  availability_zone = var.subnets[0].availability_zone//availability zone
//tags for the subnet
  tags = {
    name="public-1"
    Environment = "staging"
  }
}
//public subnet 2
resource "aws_subnet" "public-2" {
 
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[1].cidr_block 
  availability_zone = var.subnets[1].availability_zone
// tags for the subnet
  tags = {
name="public-2"
    Environment = "staging"

  }
}
//private subnet 1
resource "aws_subnet" "private-1" {

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[2].cidr_block 
  availability_zone = var.subnets[2].availability_zone
//tags for the submet
  tags = {
    name="private 1"
    Environment = "staging"
  }
}
//private subnet 4
resource "aws_subnet" "private-2" {

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnets[3].cidr_block 
  availability_zone = var.subnets[3].availability_zone
//tags for the subnet
  tags = {
    name="private 2"

    Environment = "staging"
  }
}
