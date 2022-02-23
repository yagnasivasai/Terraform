
provider "aws" {
  access_key = "AWS ACCESS KEY"
  secret_key = "AWS SECRET KEY"
  region     = "AWS REGION"
}
resource "aws_internet_gateway" "MyAWSResource" {
}
variable "vpc_id" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "us-west-2a"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}
resource "aws_route_table" "MyAWSResource" {
}
resource "aws_route_table_association" "MyAWSResource" {
}
variable "security_group_id" {}

data "aws_security_group" "selected" {
  id = var.security_group
}

resource "aws_subnet" "subnet" {
  vpc_id     = data.aws_security_group.selected.vpc_id
  cidr_block = "10.0.1.0/24"
}
resource "aws_instance" "MyAWSResource" {
  ami           = ""
  instance_type = "t2.micro"
}

