//handling networking within the cluster


resource "aws_subnet" "private-us-east-1a"{
    vpc_id=module.vpc.azs
    cidr_block="10.0.0.0/19"
    availability_zone="us-east-1a"

    tags={
        Name="private-us-east-1a"
    }

}

resource "aws_subnet" "private-us-east-1b"{
    vpc_id=module.vpc.azs
    cidr_block="10.0.32.0/19"
    availability_zone="us-east-1b"

    tags={
        Name="private-us-east-1b"
    }

}
