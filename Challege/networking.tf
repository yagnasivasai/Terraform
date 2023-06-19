resource "aws_security_group" "dynamic_security_group" {
  description = "AWS Security Group"


  dynamic "ingress" {
    iterator = port
    for_each = var.ingress
    content {
        from_port = port.value
        to_port = port.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egress
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}