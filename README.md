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
## Storage
### Expand Storage

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

### Mount Storage

See current storage, find new drive (/dev/sd{x,y,z})
```bash
sudo lsblk -f
```

Make new partition
```bash
sudo gdisk /dev/sdb
```
Then:
n (new)

1 (partition #)

<enter> (first sector, start of disk by default)

<enter> (last sector, end of disk by default)

<enter> (linux file system default)

w (write & exit)


Find new parition GGUID (/dev/sd{x,y,z}[1-9])
```bash
sudo lsblk -f
```

format partition, mount on folder
```bash
sudo mkfs.xfs /dev/sdb1
sudo mkdir /mnt/sdb1
echo /dev/disk/by-uuid/<UUID FROM lsblk -f> /mnt/sdb1 xfs defaults 0 1 | sudo tee -a /etc/fstab
sudo mount -a
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

### Make shortcut
```bash
ln -s /mnt/<path>/ ~/<end_path>
sudo chown -R $USER:$USER ~/<end_path>
```