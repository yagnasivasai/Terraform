#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 777 /var/run/docker.sock
sudo usermod -aG docker $user