provider "aws" {
  region = var.region
}


resource "aws_vpc" "challenge1vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "TerraformVPC"
  }
}


resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.dynamic_security_group.name]
  user_data       = file("server-script.sh")
  tags = {
    Name = "Web Server"
  }
}

resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
} 
