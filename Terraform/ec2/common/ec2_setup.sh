#!/bin/bash
sudo apt -y update
sudo apt install awscli -y
sudo apt install -y git htop sysvbanner tree curl unzip
sudo apt install mysql-client -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
exit
