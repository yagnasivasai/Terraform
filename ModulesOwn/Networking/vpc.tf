
# Creating a Custom VPC

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "my_vpc"
  }
}

# Creating a Internet Gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

# Creating a EIP for NAT Gateway

resource "aws_eip" "my_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.my_igw
  ]
}

# Creating a NAT Gateway

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.Public_Subnet.id
  depends_on = [
    aws_internet_gateway.my_igw
  ]
  tags = {
    Name = "My-NAT"
  }
}

# Creating a Public Subnet

resource "aws_subnet" "Public_Subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.public_az
  tags = {
    Name = "Public_subnet"
  }
}

# Creating a Private Subnet

resource "aws_subnet" "Private_Subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_cidr_block
  availability_zone       = var.private_az
  map_public_ip_on_launch = false
  tags = {
    Name = "Private_Subnet"
  }
}

# creating a Public Route table

resource "aws_route_table" "Public_Route" {
  vpc_id = aws_vpc.my_vpc.id
  route = [{
    carrier_gateway_id         = ""
    cidr_block                 = "0.0.0.0/0"
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    gateway_id                 = aws_internet_gateway.my_igw.id
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

# creating a Private Route table

resource "aws_route_table" "Private_Route" {
  vpc_id = aws_vpc.my_vpc.id
  route = [{
    carrier_gateway_id         = ""
    cidr_block                 = "0.0.0.0/0"
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    gateway_id                 = aws_nat_gateway.my_nat.id
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


# Creating Public Route table association

resource "aws_route_table_association" "Public_route_table_association" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_Route.id
}

# Creating Private Route table association

resource "aws_route_table_association" "Private_route_table_association" {
  subnet_id      = aws_subnet.Private_Subnet.id
  route_table_id = aws_route_table.Private_Route.id
}

resource "aws_security_group" "my_sg_public" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "sg_public"

}
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id

}
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id
}
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id
}
resource "aws_security_group_rule" "inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id
}
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id
}

resource "aws_security_group" "my_sg_private" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "sg_private"

}
resource "aws_security_group_rule" "ssh_private" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.my_sg.id

}
resource "aws_security_group_rule" "outbound_private" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id
}