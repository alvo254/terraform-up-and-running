terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }

  backend "remote"{
    organization = "alvo"

    workspaces{
        name = "provisioners"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_server" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]

  tags = {
    //String interpolation in terraform 
    Name = "Myserver"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDd1GlORv3kOQ1wimY4lJSeUVJ14uYFeofLb93qZA6GobjV99wrNdqaj+qKiFWRVhOZzt/TJ1DGH9AYJMFi7LCLunEFzHMNEVtdcYILDaP/ONE/xfv9QIbqRhUr/livvI+9WjBvHQooqnG2IrQnfF941MmnS2Jl+pr3Hg7miL1Ili1lfJ8hdWpMMd1HXFDeIZCZ1FUU5sM1CuvFEYP8BpsrP4ij7/BnirZrPK+G1shfQiaTk29gdGx5Fhg3dISHkpGcu9MOyd/gFGATY6eXutLt9Dru1B2ndV9Qs4AAsV6ENPCt/0Tf6/Yvq8qj5tbcOBtkn6p05oSBUMUfcosiPnMxjLaR8unIvPmObQ4Jgxw8VhWZYlP8+7bP9JmKtIbZNU4aC7eh18D+NzPD3X0+U+RHMI0Ji6zGA12QCIDY6eYFbZNJ+jQT8ypP21Vqvy9OhnLmAmK4jsrwGPNEGP9oawOy8eLbqL2Eu+W2yBA4HLtjCXQbSwqP8VB5ZOyHa/aZmS8= betty@N1GGA-LAPTOP"
}

output "public_ip" {
  value = aws_instance.my_server
}

//data sources allow us to refernce external resources
data "aws_vpc" "main"{
    id = "vpc-0df4beebc1a0823b4"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "mySever security group"
  vpc_id      = data.aws_vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    //The /32 means use a single ip
    ipv6_cidr_blocks = ["105.163.30.119/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}