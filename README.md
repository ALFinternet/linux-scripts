# linux-scripts
Scripts for Linux SETUP

## How to Use
on Ubuntu:

```bash
sudo su -
```
then

```bash
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
mv /home/$OLDUSER/* /home/$NEWUSER
mv /home/$OLDUSER/.* /home/$NEWUSER
```