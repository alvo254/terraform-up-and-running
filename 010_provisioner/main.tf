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