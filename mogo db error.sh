#!/bin/bash

# Check if MongoDB is installed
if mongod --version >/dev/null 2>&1; then
  echo "MongoDB is already installed. Version:"
  mongod --version

  # Check if MongoDB is running
  if systemctl is-active --quiet mongod; then
    echo "MongoDB is currently running."
  else
    echo "MongoDB is installed but not running."
  fi

else
  echo "MongoDB is not installed. Installing..."

  echo "Which version of MongoDB would you like to install?"
  echo "1. MongoDB 4.4"
  echo "2. MongoDB 5.0"

  read -p "Enter your choice [1-2]: " choice

  # Install the specified version of MongoDB
  case $choice in
    1)
       wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
       echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
       apt-get update
       apt-get install -y mongodb-org=4.4.* mongodb-org-server=4.4.* mongodb-org-shell=4.4.* mongodb-org-mongos=4.4.* mongodb-org-tools=4.4.*
      ;;
    2)
       wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
       echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
       apt-get update
       apt-get install -y mongodb-org=5.0.* mongodb-org-server=5.0.* mongodb-org-shell=5.0.* mongodb-org-mongos=5.0.* mongodb-org-tools=5.0.*
      ;;
    *)
      echo "Invalid MongoDB version. Please choose 4.4 or 5.0."
      exit 1
  esac
  
  # Check if installation was successful
  if systemctl is-active --quiet mongod; then
    echo "MongoDB installation complete. Version:"
    mongod --version
    echo "MongoDB is currently running."
  else
    echo "MongoDB installation failed."
  fi
fi
