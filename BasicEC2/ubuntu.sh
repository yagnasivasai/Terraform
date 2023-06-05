#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $user