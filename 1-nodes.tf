//nodes in the cluster
resource "aws_instance" "test-node" {
    
    ami           = "ami-0c92ea9c7c0380b66"
    instance_type = "t3.micro"            # in future will be changed to vars instance type
    subnet_id    = aws_subnet.private-us-east-1a.id

    tags = {
        Name = "test-node"
    }

    dynamic "instance_market_options" {
        for_each = var.capacity_type == "SPOT" ? [1] : []
        content {
            market_type = "SPOT"
            spot_options {
                max_price = "0.05"
            }
        }
    }

    dynamic "instance_market_options" {
        for_each = var.capacity_type == "fleet" ? [1] : []
        content {
            target_capacity = 2  # Spot instances
            spot_price      = "0.05"  
            iam_fleet_role  = "your_iam_fleet_role_arn" # Replace with your IAM fleet role ARN
            allocation_strategy = "diversified"  # Choose desired strategy
        }
    }

    dynamic "instance_market_options" {
        for_each = var.capacity_type == "dedicated-host" ? [1] : []
        content {
        tenancy = "host"
        }
    }
}