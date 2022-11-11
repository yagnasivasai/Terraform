provider "aws" {
  region = var.region
}

resource "aws_default_vpc" "default" { }

data "aws_availability_zones" "available" { }

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}


resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"
  vpc_id        = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_instance" "jenkins" {
  ami = var.ami
  /* count = 1 */
  key_name = var.key_name
  subnet_id = aws_default_subnet.default_az1.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.dynamicsg.id ] 
}

resource "null_resource" "name" {
  

  connection {
    
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/Downloads/automation.pem")
    host = aws_instance.jenkins.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y"

    ]
    
  }
}

output "jenkins_url" {
  value = join ("",["http://", aws_instance.jenkins.public_dns,":","80"])
}