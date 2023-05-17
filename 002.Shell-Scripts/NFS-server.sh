#!/bin/bash

apt update
apt install -y sudo
apt install -y nfs-kernel-server
systemctl status nfs-kernel-server
systemctl start nfs-kernel-server
service nfs-kernel-server status
systemctl status rpcbind.service
mkdir -p /data/nfs
ls /etc/exports
apt install -y nano
nano /etc/exports << EOF
/data/nfs *(rw,sync,no_subtree_check)
EOF
cat /etc/exports
service rpcbind status
service rpcbind start
chmod 777 /data/nfs/
systemctl status nfs-kernel-server
systemctl start nfs-kernel-server
systemctl status nfs-kernel-server
systemctl start rpcbind
cat /usr/lib/systemd/system/rpcbind.service
apt install -y rpcbind
systemctl start rpcbind
systemctl status rpcbind
apt install -y net-tools
ifconfig
apt install -y ufw
ufw allow from CLIENT-IP to any port nfs
sudo ufw enable
iptables -L
apt update
apt install -y iptables
ls /usr/sbin/ip6tables
lsmod | grep ip6table
apt install -y kmod
lsmod | grep ip6table
ufw app list
sudo ufw disable
showmount -e SERVER-IP
