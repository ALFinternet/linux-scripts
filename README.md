# linux-scripts
Scripts for Linux SETUP

## How to Use
on Ubuntu, switch to root:
```bash
sudo su -
```

Run pre-installs of apps & configs, create user netadmin
```bash
bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/ubuntu-install.sh)
```

Give netadmin a password:
```bash
passwd netadmin
```

then once ready to 'prep':

```bash
bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/ubuntu-sysprep.sh)
```

### Rename ubuntu user to new user
Logout & login as a different user (netadmin), switch to root
```bash
sudo su -
```
then
```bash
OLDUSER=ubuntu
NEWUSER=<newuser>
usermod -l $NEWUSER $OLDUSER
groupmod -n $NEWUSER $OLDUSER
usermod -d /home/$NEWUSER -m $NEWUSER
```

### Add Storage

See current storage:
```bash
sudo lsblk
```

Expand partition
```bash
sudo growpart /dev/sda 2
```

Resize root to fill space
```bash
sudo xfs_growfs /
```

### NFS Mount for Docker
```bash
sudo mkdir -p /mnt/homenas-docker-nfs-ssd
echo homenas.finchhome.xyz:/volume2/Docker-NFS-SSD /mnt/homenas-docker-nfs-ssd nfs auto,defaults,nofail 0 0 | sudo tee -a /etc/fstab
sudo mount -a
sudo chown root:root -R /mnt/homenas-docker-nfs-ssd/
sudo chmod +0776 -R /mnt/homenas-docker-nfs-ssd/
ln -s /mnt/homenas-docker-nfs-ssd/ ~/appdata
```
