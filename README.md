# linux-scripts
Scripts for Linux SETUP

## How to Use
on Ubuntu, switch to root, preinstall apps, create 2nd user, set password:

```bash
sudo su -
bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/ubuntu-install.sh)
```

then once ready to 'prep':

```bash
sudo su -
bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/prepare-ubuntu-template.sh)
```

### Rename User
Give netadmin a password:
```bash
sudo passwd netadmin
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