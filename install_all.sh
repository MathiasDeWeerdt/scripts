#! /bin/bash

# Stopping docker and removing all software prior to starting.
# This is to make sure there are no conflicts.

sudo systemctl stop docker
sudo apt remove nginx nodejs yarn docker-ce* containerd.io -y

# Doing a full update / upgrade to make sure we are good to go.
sudo apt update && sudo apt upgrade -y

# Installing dependencies we are going to need.
sudo apt install build-essential gcc g++ make wget curl gnupg2 ca-certificates lsb-release apt-transport-https gnupg-agent software-properties-common -y

# Installing the latest nginx from the official repo.
echo "deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-key fingerprint ABF5BD827BD9BF62
sudo apt update
sudo apt install nginx -y

# Installing the latest code from the official repo.
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Cleaning up the file we wrote.
sudo rm -rf packages.microsoft.gpg

# Installing docker from the official repo.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt update

# Adding our user to the docker group.
sudo usermod -aG docker $(whoami)

# Installing docker-compose from the official repo.
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Running the nodeJs script and installing from the official repo
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y

# Making sure we have the latest npm installed
sudo npm install npm@latest -g

# Installing npm packages I often use as global, so they are available everywhere.
sudo npm install yarn@latest typescript@latest jest@latest ts-jest@latest @types/jest@latest http-server@latest express@latest @types/express@latest ts-node-dev@latest vue@next @vue/cli@latest -g

# Upgrading everything to make sure, we are up-to-date.
sudo npm upgrade -g

# Doing a last update / upgrade and cleaning to make sure everything is fine and dandy.
sudo apt update && sudo apt upgrade -y
sudo apt clean -y
sudo apt auto-remove -y

# Testing docker.
sudo systemctl start docker
docker run hello-world

# Checking the versions of all the installed CLI-apps. 
nginx -v
echo "npm version $(npm -v)"
echo "node version $(node -v)"
echo "yarn version $(yarn -v)"
echo "typescript $(tsc -v)"
echo "jest version $(jest -v)"
echo "http-server version $(http-server -v)"
echo "vue cli version $(vue --version)"
docker -v