#!/bin/bash
sudo apt update -y && apt upgrade -y
sudo apt install docker.io -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
echo "alias docker='sudo docker'" >> ~/.bashrc
sudo hostnamectl set-hostname docker
sudo groupadd docker
sudo usermod -aG docker $USER