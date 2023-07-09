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


Logout & login as a different user (netadmin)
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