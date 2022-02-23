#!/bin/bash

sudo yum update -y
sudo yum upgrade -y
sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install epel-release -y
sudo yum install centos-release-scl -y
sudo yum install rh-python36 -y
scl enable rh-python36 bash
sudo yum install python3-pip -y
sudo yum install python3-devel -y
sudo yum groupinstall 'development tools'


