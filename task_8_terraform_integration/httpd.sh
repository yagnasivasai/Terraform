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