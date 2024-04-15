#!/bin/bash
######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################
# cheat & run this as sudo: bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/ubuntu-install.sh)

# modified from: jcppkkk/prepare-ubuntu-template.sh
# TESTED ON UBUNTU 18.04 LTS

# SETUP & RUN
# curl -sL https://raw.githubusercontent.com/jimangel/ubuntu-18.04-scripts/master/prepare-ubuntu-18.04-template.sh | sudo -E bash -

# forked from https://github.com/jimangel/ubuntu-18.04-scripts/blob/master/prepare-ubuntu-18.04-template.sh
# - https://jimangel.io/post/create-a-vm-template-ubuntu-18.04/

if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi

set -v

#update apt-cache
apt update -y
apt upgrade -y

#install packages
apt install -y open-vm-tools
apt install -y qemu-guest-agent
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
apt install -y haveged ntp nfs-common net-tools cifs-utils htop parted tmux p7zip-full


#set timezone
timedatectl set-timezone America/Los_Angeles

# add netadmin user,, use sudo passwd netadmin to set password
useradd -m netadmin -G sudo
usermod --shell /bin/bash netadmin


# disable MOTD & login spam
sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
chmod -x /etc/update-motd.d/10-help-text

sudo curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/00-installer-config.yaml -o /etc/netplan/00-installer-config.yaml

# run anything on login https://gist.github.com/linuswillner/f8c15385e8a88017a70bdc3f18a688a2
#cat << 'EOL' | sudo tee /etc/profile.d/motd.sh
##!/bin/bash
#printf "\n"
#neofetch
#
#EOL
#chmod +x /etc/profile.d/motd.sh
