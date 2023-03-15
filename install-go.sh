#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt remove golang* -y
sudo apt install wget -y

wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz -O /tmp/go.tar.gz
cd /tmp

echo "Removing old installation"
sudo rm -rf /usr/local/go

echo "Extracting new installation"
sudo tar -C /usr/local -xzf go.tar.gz

echo "Adding to profile."
echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.profile
source ~/.profile

go version
