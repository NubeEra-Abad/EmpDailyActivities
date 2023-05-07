#!/bin/bash

# Check if a version number was specified
if [ -z "$1" ]; then
    echo "No version specified. Please choose 3.6, 3.7, or 3.8."
    exit 1
fi

# Install the specified version of Python
case "$1" in
    3.6)
        echo "Installing Python 3.6..."
         apt-get update
         apt-get install -y python3.6
        ;;
    3.7)
        echo "Installing Python 3.7..."
         apt-get update
         apt-get install -y python3.7
        ;;
    3.8)
        echo "Installing Python 3.8..."
         apt-get update
         apt-get install -y python3.8
        ;;
    *)
        echo "Invalid version specified. Please choose 3.6, 3.7, or 3.8."
        exit 1
esac

# Check if installation was successful
if command -v python3 &>/dev/null; then
    echo "Python installation complete. Version:"
    python3 --version
else
    echo "Python installation failed."
fi
