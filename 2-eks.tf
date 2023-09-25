/*module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "19.16.0"

    cluster_name = "my-eks"
    cluster_version = "1.27"

    cluster_endpoint_private_access = true
    cluster_endpoint_public_access = true

    vpc_id = aws_vpc.vpc.id
    subnet_ids = [
        aws_subnet.private-us-east-1a.id,
        aws_subnet.private-us-east-1b.id
    ]
    

    enable_irsa = true

    eks_managed_node_group_defaults = {
        disk_size = 50
    }

    eks_managed_node_groups = {
        general = {
            desired_size = 1
            min_size = 1
            max_size = 2

            labels = {
                role = "general"
            }

            instance_types = ["t3.small"]
            capacity_type = "ON_DEMAND"
        }

        spot = {
            desired_size = 1
            min_size = 1
            max_size = 2

            labels = {
                role = "spot"
            }

            taints = [{
                key = "market"
                value = "spot"
                effect = "NO_SCHEDULE"
            }]

            instance_types = ["t3.micro"]
            capacity_type = "SPOT"
        }
    }

    tags = {
        Envrironment = "staging"
    }
}*/

resource "aws_eks_cluster" "my-eks" {

    cluster_endpoint_private_access = true
    cluster_endpoint_public_access = true

      enable_irsa = true

    eks_managed_node_group_defaults = {
        disk_size = 50
    }

    tags = {
      name=my-eks
    }
}