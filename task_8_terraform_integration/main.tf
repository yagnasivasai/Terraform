provider "aws" {
   region = var.region
}

resource "aws_instance" "terraform" {
  ami                       = var.ami
  instance_type             = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                     = var.key_name

  tags = {
    Name = "test"
    application-name = "webserver"
    project = "Holcim"
    environment = "dev"
    project-lifecycle = "dev"
    cost-center = "aws"
    map-migrated = "asia"
  }
}