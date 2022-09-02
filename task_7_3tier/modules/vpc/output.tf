output "vpc" {
  value = aws_vpc.my_vpc.id
}

output "internet_gateway" {
  value = aws_internet_gateway.my_igw.id
}

output "my_eip" {
  value = aws_eip.my_eip.id
}

output "my_nat_gw" {
  value = aws_nat_gateway.my_nat.id
}



output "webdata_agent" {
  value = aws_security_group.webdata_agent.id
}

output "webservices_analytics" {
  value = aws_security_group.webservices_analytics.id
}

output "datastore" {
  value = aws_security_group.datastore.id
}
output "webserver_sg" {
  value = aws_security_group.webserver_sg.id
}



output "subnetpublicid" {
  value = aws_subnet.public_subnet.id
}
output "subnetprivateid" {
  value = aws_subnet.private_subnet.id
}
