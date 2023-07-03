terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }

}

provider "aws" {
    region = "us-east-1"
    profile = "default"
}

resource "aws_instance" "alvin_terraform"{
    ami = "ami-0261755bbcb8c4a84"
    instance_type = "t2.micro"
	tags = {
	  Name = "alvos-terraf"
	}
}

resource "aws_s3_bucket" "terraformed-bucket" {
    bucket = "alvos-terra"
	depends_on  = [
		aws_instance.alvin_terraform
		]
    
    tags = {
        Name = "alvos"
        Environment = "Test"
    }
}

output "public_ip" {
  value       = aws_instance.alvin_terraform.public_ip
  sensitive   = true
  description = "Get instance public IP"

}
