

resource "aws_instance" "ec2test" {
  ami                         = "ami-09e67e426f25ce0d7"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "test"
  subnet_id                   = aws_subnet.test_pub_subnet.id
  vpc_security_group_ids      = [aws_security_group.test-sg.id]
  user_data                   = file("D:\\Real\\Terraform\\Shell-Scripts\\ubuntu.sh")
}
terraform {
  backend "s3" {
    bucket = "yaznasivasai"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}
output "ip" {
  value = aws_instance.ec2test.*.public_ip
}
resource "null_resource" "nginx" {
  connection {
    user        = "ubuntu"
    type        = "ssh"
    host        = aws_instance.ec2test.public_ip
    private_key = file("D:\\Real\\Terraform\\Automation-Project\\test.pem")
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 5m"
    ]

  }

}


