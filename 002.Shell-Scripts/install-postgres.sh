#!/bin/bash

# Check if a version number was specified
if [ -z "$1" ]; then
    echo "No version specified. Please choose 9.6, 10, 11, or 13."
    exit 1
fi

# Add the PostgreSQL repository to the system
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql-$1

# Check if installation was successful
if systemctl is-active --quiet postgresql; then
    echo "PostgreSQL installation complete. Version:"
    sudo -u postgres psql -c "SELECT version();"
else
    echo "PostgreSQL installation failed."
fi
