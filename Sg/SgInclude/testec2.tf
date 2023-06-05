resource "aws_instance" "ec2test" {
  ami                         = "ami-0b0af3577fe5e3532"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "test"
  subnet_id                   = aws_subnet.test_pub_subnet.id
  security_groups             = ["aws_security_group.test_sg.id"]
  vpc_security_group_ids      = ["aws_vpc_security_group."]
  user_data                   = <<-EOF
      #!/bin/bash
      sudo yum-config-manager --disable docker-ce-stable
      sudo yum update -y
      sudo yum upgrade -y
      sudo yum remove docker docker-common docker-selinux docker-engine -y
      sudo yum install vim epel-release yum-utils device-mapper-persistent-data lvm2 -y
      sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
      sudo yum-config-manager --disable docker-ce-stable
      sudo yum install docker -y
      sudo systemctl enable docker.service
      sudo systemctl start docker.service
      echo "alias docker='sudo docker'" >> ~/.bashrc
      sudo hostnamectl set-hostname docker
      sudo groupadd docker
      sudo usermod -aG docker $USER
      EOF
}


terraform {
  backend "s3" {
    bucket = "yaznasivasai"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

