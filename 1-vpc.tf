//aws vpc
resource "aws_vpc" "vpc" {
     cidr_block = "10.0.0.0/16"//cidr blovk
    instance_tenancy = "default"
      enable_dns_support = true//enables dns
      enable_dns_hostnames = true//enables dns host names
      //tags for the vpc
    tags = {
      Name ="my-vpc"
        Envrironment = "staging"

    }
}