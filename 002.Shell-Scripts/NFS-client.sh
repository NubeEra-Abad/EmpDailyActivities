#!/bin/bash

sudo apt-get update
sudo apt-get install nfs-common

sudo mkdir -p /data/nfs-client

sudo mount SERVER-IP:/data/nfs /data/nfs-client

mount | grep SERVER-IP:/data/nfs >/dev/null

if [ $? -ne 0 ]; then
    echo "Mount failed."
    exit 1
fi

sudo bash -c 'echo "SERVER-IP:/data/nfs  /data/nfs-client  nfs  defaults  0  0" >> /etc/fstab'

cd /data/nfs-client
sudo touch testfile.txt
