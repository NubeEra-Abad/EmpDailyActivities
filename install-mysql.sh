#!/bin/bash

# Check if MySQL is installed
if mysql --version >/dev/null 2>&1; then
  echo "MySQL is already installed. Version:"
  mysql --version
else
  echo "MySQL is not installed. Installing..."

  echo "Welcome to the MySQL installation script!"
  echo "Which version of MySQL would you like to install?"
  echo "1. MySQL 8.0"
  echo "2. MySQL 5.7"

  read -p "Enter your choice [1-2]: " choice

  # Install the specified version of MySQL
  case $choice in
    1)
       wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.18-1_all.deb
       dpkg -i mysql-apt-config_0.8.18-1_all.deb
       sudo apt-get update
       sudo apt-get install -y mysql-server=8.0*
      ;;
    2)
       wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.18-1_all.deb
       dpkg -i mysql-apt-config_0.8.18-1_all.deb
       sudo apt-get update
       sudo apt-get install -y mysql-server=5.7*
      ;;
    *)
      echo "Invalid MySQL version. Please choose 8.0 or 5.7."
      exit 1
  esac
  
  # Check if installation was successful
  if systemctl is-active --quiet mysql; then
    echo "MySQL installation complete. Version:"
    mysql --version
    systemctl status mysql
  else
    echo "MySQL installation sucess"
  fi
fi
