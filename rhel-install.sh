#!/bin/bash
#
###########################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS ####
###########################################################
#
#
# cheat & run this as sudo: bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/rhel-install.sh)
#

if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi

set -v

dnf config-manager --set-enabled crb
dnf install epel-release -y

dnf check-update & dnf upgrade -y

dnf install -y curl wget git haveged chrony nfs-utils net-tools cifs-utils
dnf install -y nano htop parted tmux p7zip p7zip-plugins fastfetch
dnf install -y open-vm-tools
#dnf install -y qemu-guest-agent

#set timezone
timedatectl set-timezone America/Los_Angeles

# add netadmin user,, use sudo passwd netadmin to set password
useradd -s /bin/bash -G wheel netadmin


# run anything on login
cat << 'EOL' | sudo tee /etc/profile.d/99-fastfetch.sh
#!/bin/bash
printf "\n"
fastfetch

EOL
chmod +x /etc/profile.d/99-fastfetch.sh

# set IP via nmtui or nmcli