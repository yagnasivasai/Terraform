

# Creating a Public Instance
resource "aws_instance" "ansible" {
    ami = var.ami_id
    instance_type = var.instancetype 
    key_name = "mvp"
    subnet_id = var.subnet_id
    security_groups = [var.securitygroup]

    provisioner "file" {
    source = "D:\\Mvp\\ansible.sh"
        destination = "/tmp/ansible.sh"
    }
    provisioner "remote-exec"{
        inline = [
            "chmod +x /tmp/ansible.sh",
            "sudo /tmp/ansible.sh"
        ]
    }
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.ansible.public_ip
        private_key = file("D:\\Mvp\\mvp.pem")
    }
}


