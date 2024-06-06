terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  profile = "terraform-lab6"
}

variable "vpc_id" {
  type = string
  default = "vpc-0a5396f21264f5456"
}

data "aws_vpc" "default" {
  id = var.vpc_id
}

resource "aws_security_group" "security_group_terraform" {
  name        = "security_group_terraform"
  description = "terraform"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "security_group_terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "security_group_terraform_rule1" {
  security_group_id = aws_security_group.security_group_terraform.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "security_group_terraform_rule2" {
  security_group_id = aws_security_group.security_group_terraform.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_instance" "lab6_terraform" {
  ami           = "ami-01e444924a2233b07"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.security_group_terraform.name]
  key_name = "labs"

  tags = {
    Name = "lab6_terraform"
  }
}

