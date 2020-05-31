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

usermod -aG docker alf

#systemctl enable docker
#all remote connections
#sudo nano /etc/docker/daemon.json
#sudo sed -i 's/containerd.sock/containerd.sock -H=tcp:\/\/0.0.0.0:2375/g' /lib/systemd/system/docker.service


# https://nickjanetakis.com/blog/docker-tip-73-connecting-to-a-remote-docker-daemon
# Create the directory to store the configuration file.
sudo mkdir -p /etc/systemd/system/docker.service.d
# Create a new file to store the daemon options.
sudo nano /etc/systemd/system/docker.service.d/options.conf
# Now make it look like this and save the file when you're done:
cat << 'EOL' | sudo tee /etc/systemd/system/docker.service.d/options.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H unix:// -H tcp://0.0.0.0:2375
EOL
# Reload the systemd daemon.
sudo systemctl daemon-reload
# Restart Docker.
sudo systemctl restart docker
