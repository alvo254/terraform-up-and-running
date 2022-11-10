//Provider to use aws,azure,gcp,heroku etc can be multiple as terraform is cloud agnostic
provider "aws" {
  region = "us-east-1"

}

variable "instance_type"{
    type = string
}

//Resource to be created
resource "aws_instance" "my_server" {
  ami = "ami"
  instance_type = var.instance_type
}
