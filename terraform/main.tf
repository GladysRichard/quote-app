terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}


data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


resource "aws_security_group" "quote_app_sg" {
  name = "quote-app-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "quote_app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = "quote-app-deploy-key-2"

  vpc_security_group_ids = [
    aws_security_group.quote_app_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              systemctl start docker
              systemctl enable docker
              docker pull gladysrichard/quote-app:latest
              docker run -d -p 80:80 --name quote-app gladysrichard/quote-app:latest
              EOF

  tags = {
    Name = "quote-app-server"
  }
}


output "website_url" {
  value = "http://${aws_instance.quote_app_server.public_ip}"
}