resource "aws_security_group" "test_sg" {
  vpc_id = aws_vpc.test_vpc.id
  name   = "test-sg"

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "ssh"
      from_port        = "22"
      to_port          = "443"
      ipv6_cidr_blocks = ["::/0"]
      protocol         = "tcp"
      security_groups  = ["aws_security_group.test_sg.id"]
      self             = false
      prefix_list_ids  = []
    }
  ]
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "ssh"
      from_port        = "0"
      to_port          = "0"
      ipv6_cidr_blocks = ["::/0"]
      protocol         = "tcp"
      security_groups  = ["aws_security_group.test_sg.id"]
      self             = false
      prefix_list_ids  = []
    }
  ]
}