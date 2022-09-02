resource "aws_instance" "webdata_agent" {
  ami             = var.ami_id
  instance_type   = var.instancetype
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = [var.securitygroup]
  ebs_optimized = Yes
  root_block_device {
    volume_size = "10"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y apache2",
      "sudo service apache2 start"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.webdata_agent.public_ip
    private_key = file(var.key_path)
  }
}

resource "aws_ebs_volume" "webdata_agent_volume" {
  availability_zone = aws_instance.webdata_agent.availability_zone
  size              = 1
  tags = {

    Name = "${var.project_name}-${var.environment}-volume",
  }
}
resource "aws_volume_attachment" "webebsAttach" {

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.webdata_agent_volume.id
  instance_id = aws_instance.webdata_agent.id

}

output "aws_instance_private_dns" {
  value  = aws_instance.webdata_agent.private_dns
}

output "aws_instance_private_ip" {
  value  = aws_instance.webdata_agent.private_ip
}

