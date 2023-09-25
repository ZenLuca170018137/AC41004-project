//nodes in the cluster
//
resource "aws_instance" "test-node" {
    
  ami           = ""//dont know where to obtain the machine image
  instance_type = "t2.micro"            # Specify the instance type
  subnet_id    = aws_subnet.private-us-east-1a

  tags = {
    Name = "test-node"
  }
}