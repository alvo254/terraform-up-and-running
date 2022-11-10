//Provider to use aws,azure,gcp,heroku etc can be multiple as terraform is cloud agnostic
provider "aws" {
  region = "us-east-1"

}

variable "instance_type"{
    type = string
}

locals {
  project_name = "Alvin"
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
