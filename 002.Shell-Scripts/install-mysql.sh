#!/bin/bash

# Check if a version number was specified
if [ -z "$1" ]; then
    echo "No version specified. Please choose 5.7 or 8.0."
    exit 1
fi

# Install the specified version of MySQL
case "$1" in
    5.7)
        echo "Installing MySQL 5.7..."
        sudo apt-get update
        sudo apt-get install -y mysql-server=5.7*
        ;;
    8.0)
        echo "Installing MySQL 8.0..."
        sudo apt-get update
        sudo apt-get install -y mysql-server=8.0*
        ;;
    *)
        echo "Invalid version specified. Please choose 5.7 or 8.0."
        exit 1
esac

# Check if installation was successful
if systemctl is-active --quiet mysql; then
    echo "MySQL installation complete. Version:"
    mysql --version
else
    echo "MySQL installation failed."
fi
