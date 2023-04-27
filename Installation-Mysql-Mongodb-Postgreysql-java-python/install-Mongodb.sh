#!/bin/bash

# Check if a version number was specified
if [ -z "$1" ]; then
    echo "No version specified. Please choose 4.4 or 5.0."
    exit 1
fi

# Import the MongoDB public key
wget -qO - https://www.mongodb.org/static/pgp/server-$1.asc | sudo apt-key add -

# Add the MongoDB repository to the system
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/$1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$1.list

# Install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org=$1.* mongodb-org-server=$1.* mongodb-org-shell=$1.* mongodb-org-mongos=$1.* mongodb-org-tools=$1.*

# Check if installation was successful
if systemctl is-active --quiet mongod; then
    echo "MongoDB installation complete. Version:"
    mongo --version
else
    echo "MongoDB installation failed."
fi
