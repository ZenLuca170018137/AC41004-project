provider "aws" {
  region = "us-east-1"
  access_key = "ASIA5KSRLFHIJDGQLXGL"
  secret_key = "mpmBH48tBt/xTcMO9zX523FjhlqqF6X0bCmLxx1P"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }

  required_version = "~> 1.0"
}
