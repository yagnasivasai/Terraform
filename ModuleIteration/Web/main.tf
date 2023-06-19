variable "server_names" {
  type = list(string)
}


resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  /* security_groups = [aws_security_group.dynamic_security_group.name] */
  /* user_data       = file("server-script.sh") */
  count = length(var.server_names)
  tags = {
    Name = var.server_names[count.index]
  }
}