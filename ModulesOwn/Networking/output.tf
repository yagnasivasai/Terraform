output "vpc" {
  value = aws_vpc.my_vpc.id
}

output "internet_gateway" {
    value = aws_internet_gateway.my_igw.id
}

output "EIP" {
   value = aws_eip.my_eip.id
}

output "NAT-GATEWAY" {
  value = aws_nat_gateway.my_nat.id
}



output "sg_pub_id" {
  value = aws_security_group.my_sg_public.id
}

output "sg_priv_id" {
  value = aws_security_group.my_sg_private.id
}