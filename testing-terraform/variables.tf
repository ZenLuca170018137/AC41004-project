#defaults can be removed to properly test that inputs are being received

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "my_eks"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "namespaces" {
  type    = list(string)
  default = ["my_namespace"]
}

variable "ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }]
}

variable "capacity" {
  type = list(object({
    desired_size = number
    min_size = number
    max_size = number
    instance_types = list(string)
    capacity_type = string
  }))
  default = [{
    desired_size = 1
    min_size = 1
    max_size = 2
    instance_types = ["t3.micro"]
    capacity_type = "SPOT"
  }]
}