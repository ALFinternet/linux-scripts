#!/bin/bash
###########################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS ####
###########################################################
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

apt install -y apt-transport-https ca-certificates curl wget git gnupg-agent software-properties-common
apt install -y haveged ntp nfs-common net-tools cifs-utils htop parted tmux p7zip-full neofetch ubuntu-drivers-common
apt install -y open-vm-tools
#apt install -y qemu-guest-agent

#set timezone
timedatectl set-timezone America/Los_Angeles

# add netadmin user,, use sudo passwd netadmin to set password
useradd -m netadmin -G sudo
usermod --shell /bin/bash netadmin


# disable MOTD & login spam
sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
chmod -x /etc/update-motd.d/10-help-text

# disable ESM notifications since we'll never use/register
# https://bugs.launchpad.net/ubuntu/+source/update-notifier/+bug/2015420
# https://github.com/canonical/ubuntu-pro-client/issues/2458
sudo touch /var/lib/update-notifier/hide-esm-in-motd
sudo rm /var/lib/update-notifier/updates-available


# set DHCP to use MAC address
#sudo curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/00-installer-config.yaml -o /etc/netplan/00-installer-config.yaml
sed -i 's/dhcp4: true/dhcp4: true\n      dhcp-identifier: mac/g' /etc/netplan/50-cloud-init.yaml

# run anything on login https://gist.github.com/linuswillner/f8c15385e8a88017a70bdc3f18a688a2
cat << 'EOL' | sudo tee /etc/profile.d/motd.sh
#!/bin/bash
printf "\n"
neofetch

EOL
chmod +x /etc/profile.d/motd.sh

# disable cloud-init all together
sudo touch /etc/cloud/cloud-init.disabled

######################################################################################################################
######################################################################################################################
# DO CLEAN UP...

#Stop services for cleanup
service rsyslog stop

#clear audit logs
if [ -f /var/log/wtmp ]; then
    truncate -s0 /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    truncate -s0 /var/log/lastlog
fi

#cleanup /tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

#cleanup current ssh keys
rm -f /etc/ssh/ssh_host_*

#add check for ssh keys on reboot...regenerate if neccessary
cat << 'EOL' | sudo tee /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# dynamically create hostname (optional)
#if hostname | grep localhost; then
    #hostnamectl set-hostname "$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')"
#fi

test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

# make sure the script is executable
chmod +x /etc/rc.local

#reset hostname
# prevent cloudconfig from preserving the original hostname
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
truncate -s0 /etc/hostname
hostnamectl set-hostname CHANGEME


# reset machine-id by deleting the file & then creating a blank place holder
# files: /etc/machine-id & /var/lib/dbus/machine-id
# ALFinternet 2020-04-16
# sudo rm -f /etc/machine-id
# sudo touch /etc/machine-id
rm /etc/machine-id
rm /var/lib/dbus/machine-id
truncate -s 0 /var/lib/dbus/machine-id
ln -s /var/lib/dbus/machine-id /etc/machine-id

#cleanup apt
apt clean

#cleanup shell history
cat /dev/null > ~/.bash_history && history -c
history -w

#shutdown
shutdown -h now
