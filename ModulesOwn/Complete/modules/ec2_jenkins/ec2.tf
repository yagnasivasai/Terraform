

# Creating a Public Instance

resource "aws_instance" "jenkins" {
  ami             = var.ami_id
  instance_type   = var.instancetype
  key_name        = "mvp"
  subnet_id       = var.subnet_id
  security_groups = [var.securitygroup]

  provisioner "file" {
    source      = "D:\\Mvp\\jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins.sh",
      "sudo /tmp/jenkins.sh"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.jenkins.public_ip
    private_key = file("D:\\Mvp\\mvp.pem")
  }
}



