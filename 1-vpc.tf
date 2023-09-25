//aws vpc
resource "aws_vpc" "vpc" {
    cidr = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Envrironment = "staging"
    }
}