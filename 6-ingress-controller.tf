//
//create security group
resource "aws_security_group" "ingress_controller" {
    description = "controls all "
    vpc_id = aws_vpc.vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  //security_group_id =""
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/8"]
}

tags={
    Name="ingress_controller"
}
}
module "aws_ingress_controller" {


source="https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml"
    cluster_name="my-eks"
    cluster_oidc_issuer_url=module.eks.cluster_oidc_issuer_url
    cluster_oidc_issuer=module.eks.cluster_oidc_issuer
    cluster_oidc_provider_arn=module.eks.cluster_oidc_provider_arn
    cluster_oidc_provider_url=module.eks.cluster_oidc_provider_url

    tags={
        Name="aws_ingress_controller"
    }
  
}
