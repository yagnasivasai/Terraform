#! /bin/bash

sudo yum update -y
sudo yum upgrade -y
sudo yum install -y git
sudo yum install -y python3-pip
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "<html><h1>Hello, world!</h1></html>" > /var/www/html/index.html


