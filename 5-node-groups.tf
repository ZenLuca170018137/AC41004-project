//node group to be created within the cluster
resource "aws_eks_node_group" "general" {
cluster_name = var.cluster_name//cluster name
    node_role_arn = aws_iam_role.worker.arn//iam role attatched to the node group
     node_group_name = "general"//node group name
    subnet_ids = [

        aws_subnet.private-1.id,
        aws_subnet.private-2.id
    ]//subnets where the nodes can be attatched to 
    //scalling config which shows the  mx min and desired number of nodes
    // this numbers have to be specified in the config file
    scaling_config {
        desired_size = var.capacity.desired_size
        max_size     = var.capacity.max_size
        min_size     = var.capacity.min_size
    }
    //update config for the node group
    update_config {
        max_unavailable = "1"
    }
  
    ami_type = "AL2_x86_64"

    capacity_type = var.capacity.capacity_type
    instance_types = var.capacity.instance_types
   
    disk_size = 40
    labels = {
        "Environment" = "staging"
    }
//all this resources have to be created before the nodegroup and nodes have been created
    depends_on = [ aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
     aws_eks_cluster.my-eks,
     aws_vpc.vpc,
     aws_subnet.private-1,
     aws_subnet.private-2,
]
//tags for the node gorup
  tags = {
    Name = "general"
    Environment = "staging"
  }
}
