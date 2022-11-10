//Provider to use aws,azure,gcp,heroku etc can be multiple as terraform is cloud agnostic
terraform { 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "3.58.0"
    }
  }
  cloud {
    organization = "alvo"

    workspaces {
      name = "learner"
    }
  }
}



provider "aws" {
  region = "us-east-1"
  # profile = "default"

}

variable "instance_type"{
    type = string
}

//Inline with code
locals {
  project_name = "Alvin-learning"
}

//Resource to be created
resource "aws_instance" "my_server" {
  ami = "ami-08c40ec9ead489470"
  instance_type = var.instance_type

  tags = {
    //String interpolation in terraform 
    Name = "Myserver-${local.project_name}"
  }
}



//Models form terraform registry
//Terrafrom init to install the module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  //Availability zone
  //Subnets can currently only be created in the following availability 
  //availability zones: us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1e, us-east-1f
  azs             = ["us-east-1a", "us-east-1b", "us-east-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}