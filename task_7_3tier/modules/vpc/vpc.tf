locals {
  name-prefix = "${var.project_name}-${var.environment}"
}

# Creating a Custom VPC

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${local.name-prefix}-vpc"
  }
}

# Creating a Internet Gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.name-prefix}-igw"
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
  subnet_id     = aws_subnet.public_subnet.id
  depends_on = [
    aws_internet_gateway.my_igw
  ]
  tags = {
    Name = "${local.name-prefix}-nat"
  }
}

# Creating a Public Subnet

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.public_az
  tags = {
    Name = "${local.name-prefix}-public-sub"
  }
}

# Creating a Private Subnet

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_cidr_block
  availability_zone       = var.private_az
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.name-prefix}-private-sub"
  }
}

# creating a Public Route table

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}
# creating a Private Route table

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }
}


# Creating Public Route table association

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# Creating Private Route table association

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_security_group" "webserver_sg" {
  name        = "${local.name-prefix}-webserver"
  description = "Allow inbound&Outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name-prefix}-webserver_sg"
  }
}

resource "aws_security_group" "webservices_analytics" {
  name        = "${local.name-prefix}-sg1"
  description = "Allow inbound traffic from webserver_sg & datastore instnaces."
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webserver_sg.id, aws_security_group.datastore.id]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webserver_sg.id, aws_security_group.datastore.id]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webserver_sg.id, aws_security_group.datastore.id]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webserver_sg.id, aws_security_group.datastore.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name-prefix}-webservices_analytics"
  }
}

resource "aws_security_group" "datastore" {
  name        = "${local.name-prefix}-sg2"
  description = "Allow traffic from webservices_analytics & webdata_agent"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webdata_agent.id, aws_security_group.webservices_analytics.id]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webdata_agent.id, aws_security_group.webservices_analytics.id]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.webdata_agent.id, aws_security_group.webservices_analytics.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name-prefix}-datastore"
  }
}

resource "aws_security_group" "webdata_agent" {
  name        = "${local.name-prefix}-sg3"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name-prefix}-webdata_agent"
  }
}




# creating a Public Route table

/* resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_vpc.id
  route = {
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
    core_network_arn           = ""
  }
} */
/* resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.my_vpc.id
  route = {
    carrier_gateway_id         = ""
    cidr_block                 = "0.0.0.0/0"
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    gateway_id                 = ""
    instance_id                = ""
    ipv6_cidr_block            = ""
    local_gateway_id           = ""
    nat_gateway_id             = aws_nat_gateway.my_nat.id
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
    core_network_arn           = ""
  }
} */
