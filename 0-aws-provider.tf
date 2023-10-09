//provider 
provider "aws" {
  region = var.region
}
 //configuration for the s3 bucket that the fstate can be stored
terraform {
  backend "s3" {
    bucket                  = "awsbucketteam-8"
    key                     = "my-terraform-project"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}
//terraform resources that need to be initialised 
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

  required_version = "~> 1.0"//
}

