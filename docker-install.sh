#!/bin/bash


if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi

set -v

#update apt-cache
apt update -y

#install packages
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update -y

apt-get install docker-ce docker-ce-cli containerd.io -y

usermod -aG docker $USER

#systemctl enable docker
#all remote connections
sudo sed -i 's/containerd.sock/containerd.sock -H=tcp:\/\/0.0.0.0:2375/g' /lib/systemd/system/docker.service