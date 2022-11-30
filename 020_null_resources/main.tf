terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }

  backend "remote"{
    organization = "alvo"

    workspaces{
        name = "Null-resource"
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

locals {
  project_name = "null_resources"
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

resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "awd ec2 wait instance-status-ok --instance-ids ${aws_instance.my_server.id}"
  }
  depends_on = [
    aws_instance.my_server
  ]
}


