provider "aws" {
  region = var.region
}

data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}


resource "aws_instance" "ec2test" {
  ami                         = data.aws_ami.example.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "K8s"
  subnet_id                   = aws_subnet.test_pub_subnet.id
  vpc_security_group_ids      = [aws_security_group.test-sg.id]
  user_data                   = file("ubuntu.sh")

  depends_on = [aws_route_table.test_pub_rt]

}
# terraform {
#   backend "s3" {
#     bucket = "terraformtestingtranslab"
#     key    = "terraform.tfstate"
#     region = "us-east-2"
#   }
# }
output "ip" {
  value = aws_instance.ec2test.*.public_ip
}
resource "null_resource" "nginx" {
  connection {
    user        = "ubuntu"
    type        = "ssh"
    host        = aws_instance.ec2test.public_ip
    private_key = file("~/Downloads/K8s.pem")
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 1m",
      "sudo docker pull 1010/nginxweb:1010",
      "sudo docker run -d --name nginxweb -p 8081:80 1010/nginxweb:1010",
      "echo $BUILD_NUMBER"
    ]

  }

}


