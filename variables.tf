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

variable "ingress_https" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
  })
  default = ({
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
  })
}

variable "ingress_http" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
  })
  default = ({
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
  })
}

variable "ingress_custom" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
  })
  default = ({
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
  })
}

variable "capacity" {
  type = object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_type  = string
  })
  default = ({    
    desired_size   = 1
    min_size       = 1
    max_size       = 4
    instance_types = ["t2.small"]
    capacity_type  = "ON_DEMAND"
})
}