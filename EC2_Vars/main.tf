provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2test" {
  count                       = "1"
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.test_pub_subnet.id
  vpc_security_group_ids      = [aws_security_group.test-sg.id]
  user_data                   = file("D:\\Terraform_Test\\script.sh")
  tags = {
    Name = "test_instance"
  }
}
output "ip" {
  value = aws_instance.ec2test.*.public_ip
}
