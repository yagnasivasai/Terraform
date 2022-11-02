provider "aws" {
  region = var.region
}
data "aws_secretsmanager_secret" "sm" {
  name = "sshkey"
}

data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = data.aws_secretsmanager_secret.sm.id
}
resource "aws_instance" "terraform" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  user_data                   = file("httpd.sh")

  tags = {
    Name              = "test"
    application-name  = "webserver"
    project           = "Holcim"
    environment       = "dev"
    project-lifecycle = "dev"
    cost-center       = "aws"
    map-migrated      = "asia"
  }
  /* provisioner "file" {
    source      = "E:\\terraform-iac-usecases\\terraform-aws-ansible-lab\\automation.pem"
    destination = "/home/ubuntu"
  } */

  provisioner "remote-exec" {
    inline = [
      "sleep 5m",
      "sudo docker pull yaznasivasai/web:v1",
      "sudo docker run -d --name nginxweb -p 8081:80 yaznasivasai/web:v1",
      "echo $BUILD_NUMBER"
    ]
    connection {
      user        = "ubuntu"
      type        = "ssh"
      private_key = data.aws_secretsmanager_secret_version.secret-version.secret_string
      host        = aws_instance.terraform.public_ip
    }
  }
}



