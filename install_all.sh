#! /bin/bash

sudo systemctl stop docker
sudo apt remove nginx nodejs yarn docker-ce* containerd.io -y

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential gcc g++ make wget curl gnupg2 ca-certificates lsb-release apt-transport-https gnupg-agent software-properties-common -y

echo "deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-key fingerprint ABF5BD827BD9BF62
sudo apt update
sudo apt install nginx -y

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
sudo rm -rf packages.microsoft.gpg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt update

sudo usermod -aG docker $(whoami)

curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y

sudo npm install npm@latest -g
sudo npm install yarn@latest typescript@latest jest@latest ts-jest@latest @types/jest@latest http-server@latest express@latest @types/express@latest ts-node-dev@latest vue@next @vue/cli@latest -g

sudo npm upgrade -g

sudo apt update && sudo apt upgrade -y
sudo apt clean -y
sudo apt auto-remove -y

sudo systemctl start docker

docker run hello-world

nginx -v
echo "npm version $(npm -v)"
echo "node version $(node -v)"
echo "yarn version $(yarn -v)"
echo "typescript $(tsc -v)"
echo "jest version $(jest -v)"
echo "http-server version $(http-server -v)"
echo "vue cli version $(vue --version)"
docker -v