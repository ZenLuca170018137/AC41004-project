#defaults can be removed to properly test that inputs are being received

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "my_eks"
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      cidr_block        = "10.0.0.0/19"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.32.0/19"
      availability_zone = "us-east-1b"
    },
    {
       cidr_block        = "10.0.64.0/19"
      availability_zone = "us-east-1a"

    },
    {
      cidr_block        = "10.0.96.0/19"
      availability_zone = "us-east-1b"
    }

    
  
  ]
}


variable "namespaces" {
  type    = list(string)
  default = ["my_namespace"]
}

variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  default = [
    {
      description = "Allow TLS (HTTPS) inbound traffic from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
    {
      description = "Allow HTTP (HTTP) inbound traffic from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    },
    {
      description = "Allow custom port (8080) inbound traffic from VPC"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
    }
  ]
}

variable "capacity" {
  type = list(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_type  = string
  }))
  default = [{
    desired_size   = 1
    min_size       = 1
    max_size       = 2
    instance_types = ["t3.micro"]
    capacity_type  = "SPOT"
  }]
}
