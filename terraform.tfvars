/* # this file sets default values for variables; if we modify these
# with preferences specified in config file before running
# terraform, this could be easy place to set values

region       = "us-east-1"
cluster_name = "my_eks"
subnet_ids   = ["10.0.0.0/19", "10.0.32.0/19"]
namespaces   = ["my_namespace"]

ingress = [{
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}]

capacity = [{
  desired_size   = 1
  min_size       = 1
  max_size       = 2
  instance_types = ["t3.micro"]
  capacity_type  = "SPOT"
}] */
