provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "test_vpc"
  }
}
resource "aws_subnet" "test_pub_subnet" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "test_pub_subnet"
  }
}
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name : "test_igw"
  }
}
resource "aws_route_table" "test_pub_rt" {
  vpc_id = aws_vpc.test_vpc.id
  route = [{
    carrier_gateway_id         = ""
    cidr_block                 = "0.0.0.0/0"
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    gateway_id                 = aws_internet_gateway.test_igw.id
    instance_id                = ""
    ipv6_cidr_block            = ""
    local_gateway_id           = ""
    nat_gateway_id             = ""
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
  }]
}
resource "aws_route_table_association" "test_pub_rta" {
  subnet_id      = aws_subnet.test_pub_subnet.id
  route_table_id = aws_route_table.test_pub_rt.id
}
resource "aws_security_group" "test-sg" {
  vpc_id = aws_vpc.test_vpc.id
  name   = "sg1"
}
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test-sg.id

}
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test-sg.id
}
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test-sg.id
}
resource "aws_security_group_rule" "inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test-sg.id
}
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test-sg.id
}

resource "aws_instance" "ec2test" {
  count                       = "1"
  ami                         = "ami-0b0af3577fe5e3532"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "test"
  subnet_id                   = aws_subnet.test_pub_subnet.id
  vpc_security_group_ids      = [aws_security_group.test-sg.id]
  user_data                   = file("D:\\terraform\\script.sh")
  tags = {
    Name = "test_instance"
  }
}
output "ip" {
  value = aws_instance.ec2test.*.public_ip
}
