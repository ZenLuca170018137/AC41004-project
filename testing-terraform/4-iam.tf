//IAM roles and policies for Amazon EKS are used to manage permissions for applications and resources deployed on the cluster

resource "aws_iam_role" "eks_self_managed_node_group" {
    name = "eks_self_managed_node_group"
    assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
    }
   
    POLICY
     tags={
        Name="eks_self_managed_node_group"
    }
}
//worker node policy
resource "aws_iam_role_policy_attachment" "amazoneks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role=aws_iam_role.eks_self_managed_node_group.name
  
}
//cni policy
resource "aws_iam_instance_profile" "cni" {
    //policy_arn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role=aws_iam_role.eks_self_managed_node_group.name
  
}
//ec2 policy
//ingress controller policy
resource "aws_iam_policy" "alb_ingress_controller" {

}
//ingress controller role
resource "aws_iam_role" "alb_ingress_controller" {

}

//policy attatchment for ingress controller
resource "aws_iam_role_policy_attachment" "alb_ingress_controller" {

}




