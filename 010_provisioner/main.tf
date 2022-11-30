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
  //This is interpolation or directive
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data = data.template_file.user_data.rendered

  //NOTE most of the provisioners require to be in a connection block
  //local exec - allows you to execute local commands after a resource is provisioned
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  provisioner "file" {
    content = "ami used: ${self.ami}"
    destination = "/home/alvo.txt"
    connection {
      type = "ssh"
      user = "ec2-user"
      # password = "${var.root_password}"
      host = "${var.public_ip}"
      private_key = "${file("/home/.ssh/id_rsa")}"
    }
  }

  //Same as local exec but for remote execution on terraform cloud
  provisioner "remote-exec" {
    inline = [
      "echos ${self.private_ip} >> home/ec2-user/private_ip.txt"
    ]
  }
  //Connection block tells provisioner how to establish connection
  connection {
    type = "ssh"
    user = "ec2-user"
    # password = "${var.root_password}"
    host = "${var.public_ip}"
    private_key = "${file("/home/.ssh/id_rsa")}"
  }

  tags = {
    //String interpolation in terraform 
    Name = "Myserver"
  }
}

//This installs the ssh key onto the server
resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDd1GlORv3kOQ1wimY4lJSeUVJ14uYFeofLb93qZA6GobjV99wrNdqaj+qKiFWRVhOZzt/TJ1DGH9AYJMFi7LCLunEFzHMNEVtdcYILDaP/ONE/xfv9QIbqRhUr/livvI+9WjBvHQooqnG2IrQnfF941MmnS2Jl+pr3Hg7miL1Ili1lfJ8hdWpMMd1HXFDeIZCZ1FUU5sM1CuvFEYP8BpsrP4ij7/BnirZrPK+G1shfQiaTk29gdGx5Fhg3dISHkpGcu9MOyd/gFGATY6eXutLt9Dru1B2ndV9Qs4AAsV6ENPCt/0Tf6/Yvq8qj5tbcOBtkn6p05oSBUMUfcosiPnMxjLaR8unIvPmObQ4Jgxw8VhWZYlP8+7bP9JmKtIbZNU4aC7eh18D+NzPD3X0+U+RHMI0Ji6zGA12QCIDY6eYFbZNJ+jQT8ypP21Vqvy9OhnLmAmK4jsrwGPNEGP9oawOy8eLbqL2Eu+W2yBA4HLtjCXQbSwqP8VB5ZOyHa/aZmS8= betty@N1GGA-LAPTOP"
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

//data sources allow us to refernce external resources
data "aws_vpc" "main"{
    id = "vpc-0df4beebc1a0823b4"
}

data "template_file" "user_data"{
  template = file("./userdata.yaml")
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "mySever security group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [ 
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      ipv6_cidr_blocks = []

  },
  {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      //The /32 means use a single ip
      cidr_blocks      = ["105.163.30.119/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
  }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false

  }
  ]

  tags = {
    Name = "allow_tls"
  }
}