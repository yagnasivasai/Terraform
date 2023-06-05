resource "aws_instance" "webserver" {
  ami             = var.ami_id
  instance_type   = var.instancetype
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = [var.securitygroup]


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y apache2",
      "sudo service apache2 start"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.webserver.public_ip
    private_key = file(var.key_path)
  }
}

resource "aws_ebs_volume" "webserver_volume" {
  availability_zone = aws_instance.webserver.availability_zone
  size              = 1
  tags = {

    Name = "${var.project_name}-${var.environment}-volume",
  }
}
resource "aws_volume_attachment" "webebsAttach" {

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.webserver_volume.id
  instance_id = aws_instance.webserver.id

}
output "aws_instance_public_dns" {
  value = aws_instance.webserver.public_dns
}
output "aws_instance_public_ip" {
  value = aws_instance.webserver.public_ip
}
