
resource "aws_eks_node_group" "general"{
    node_role_arn = ""
 
cluster_name="my-eks"

scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
}
  instance_types = ["t3.small"]
  capacity_type = "ON_DEMAND"
}

resource "aws_eks_node_group" "spot"{
 node_role_arn = ""
cluster_name="my-eks"

  instance_types =[
    "t3.small",
    "t3.medium",
   
  ]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  tags={
    "spot"="true"
  }
 
}
