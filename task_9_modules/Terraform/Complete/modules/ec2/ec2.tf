
resource "aws_instance" "private" {
  ami             = var.ami_id
  instance_type   = var.instancetype
  key_name        = "mvp"
  subnet_id       = var.subnet_id
  security_groups = [var.securitygroup]
}


