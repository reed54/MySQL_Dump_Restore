#!/bin/bash
sudo apt-get -y update
sudo apt install awscli -y
sudo echo "banner Source"  >> /home/ubuntu/.bashrc
sudo apt-get install -y git htop sysvbanner
sudo apt-get install mysql-client -y
exit