terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0adc32e81d2804255" // VPC US East
}

variable "ami_id" {
  type    = string
  default = "ami-0889a44b331db0194" // Amazon Linux 64-bit (x86)) Free Tier Eligible
}

resource "aws_security_group" "allow_traffic" {
  name   = "tomsawyer_sg"
  vpc_id = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Custom HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_traffic.id]
  associate_public_ip_address = true
  key_name                    = "<pem_file_name>"

  tags = {
    Name = "TomSawyerServerInstance"
  }
}

output "scp-cmd" {
  value = "scp -i ~/.ssh/<pem_file_name> my-project.zip ec2-user@${aws_instance.app_server.public_dns}:/home/ec2-user/."
  description = "Use this command to send the ZIP file to the EC2 instance."
}

output "ssh-cmd" {
  value = "ssh -i ~/.ssh/<pem_file_name> ec2-user@${aws_instance.app_server.public_dns}"
  description = "Use this command to connect to the EC2 instance."
}

output "app-url" {
  value = "http://${aws_instance.app_server.public_dns}:8080"
  description = "Use this URL to access the web application once is deployed in the EC2 instance."
}

output "app-server-public-dns" {
  value = "${aws_instance.app_server.public_dns}"
  description = "This is the public DNS of the EC2 instance."
}
