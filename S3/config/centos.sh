#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/rhel/docker-ce.repo
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
echo "alias docker='sudo docker'" >> ~/.bashrc
sudo hostnamectl set-hostname docker
sudo groupadd docker
sudo usermod -aG docker $USER