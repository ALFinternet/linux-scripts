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
ln -s /mnt/<path> ~/<end_path> # no trailing slashes
sudo chown -R $USER:$USER ~/<end_path>/ # has trailing slash!
```

### Docker notes
```bash
docker network create --driver=macvlan --gateway=192.168.1.1 --subnet=192.168.1.0/24 -o parent=ens3 dmac0
docker network create --driver=macvlan --gateway=192.168.1.1 --subnet=192.168.1.0/24 -o parent=ens160 dmac0
```

### Misc
Thin provision freeup, try:
```bash
sudo fstrim -av
```
else:
https://manpages.ubuntu.com/manpages/focal/en/man8/fstrim.8.html
https://kb.vmware.com/s/article/2136514
https://manpages.ubuntu.com/manpages/xenial/man8/zerofree.8.html


### Disk notes
```
Identify Disk: Run lsblk to find your new disk (e.g., /dev/sdb).
Start gdisk: Open the disk: sudo gdisk /dev/sdb.
Create GPT: In gdisk, type o (to create a new empty GPT) and y (to confirm).
Create Partition: Type n, accept defaults for partition number/start/end to use the whole disk, and set filesystem type (e.g., 8300 for Linux filesystem).
Write & Exit: Type w and y to write changes. 
Final Steps (Both Methods)
Format: sudo mkfs.ext4 /dev/sdb1 (replace sdb1 with your new partition).
Create Mount Point: sudo mkdir /mnt/newdisk (or similar).
Mount: sudo mount /dev/sdb1 /mnt/newdisk.
Auto-mount (Optional): Add a line to /etc/fstab for automatic mounting after reboot (use blkid to get the UUID). 
Note: GPT is ideal for disks > 2TB and works well with UEFI systems; ensure your system boots in UEFI mode for best results. 
```