provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc
}

resource "aws_subnet" "custom_sub" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = var.subnet
}


resource "aws_instance" "Name" {
  count             = "2"
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.AvailabilityZone
  subnet_id         = aws_subnet.custom_sub.id
  tags = {
    Name = "HelloWorld"
  }
}