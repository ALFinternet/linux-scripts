#!/bin/bash

# install items
# might need to install this manually to download this file from github:
yum install -y git

yum install -y open-vm-tools epel-release nano nfs-utils yum-utils
yum install -y bind-utils wget mlocate vim-enhanced cups net-snmp net-snmp-utils net-tools

yum install -y haveged

systemctl disable firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# http://everything-virtual.com/2016/05/06/creating-a-centos-7-2-vmware-gold-template/

#stop logging services
/sbin/service rsyslog stop
/sbin/service auditd stop

#remove old kernels
/bin/package-cleanup –oldkernels –count=1

#clean yum cache
/usr/bin/yum clean all

#force logrotate to shrink logspace and remove old logs as well as truncate logs
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

#remove udev hardware rules
/bin/rm -f /etc/udev/rules.d/70*

#remove uuid from ifcfg scripts
#this doesn't work
#/bin/sed –i ".bak" '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-ens192

#remove SSH host keys
/bin/rm -f /etc/ssh/*key*
#remove root users shell history
/bin/rm -f ~root/.bash_history
unset HISTFILE
#remove root users SSH history
/bin/rm -rf ~root/.ssh/

# reset machine-id by deleting the file & then creating a blank place holder
# files: /etc/machine-id
# ALFinternet 2020-04-16
/bin/rm -f /etc/machine-id
/bin/touch /etc/machine-id

# run these 2 commands afterwards:
# history –c
# sys-unconfig <-- this doesn't even work in CentOS8
