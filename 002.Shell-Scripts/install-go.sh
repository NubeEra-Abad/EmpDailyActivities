#!/bin/bash

# Check if Go is already installed
if command -v go &>/dev/null; then
    echo "Go is already installed. Version:"
    go version
    exit 0
fi

# Check if a version number was specified
if [ -z "$1" ]; then
    echo "No version specified. Please choose 1.16, 1.17, or 1.18."
    exit 1
fi

# Download and install the specified version of Go
case "$1" in
    1.16)
        echo "Installing Go 1.16..."
        curl -sSL https://golang.org/dl/go1.16.10.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
        ;;
    1.17)
        echo "Installing Go 1.17..."
        curl -sSL https://golang.org/dl/go1.17.5.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
        ;;
    1.18)
        echo "Installing Go 1.18..."
        curl -sSL https://golang.org/dl/go1.18.2.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
        ;;
    *)
        echo "Invalid version specified. Please choose 1.16, 1.17, or 1.18."
        exit 1
esac

# Check if installation was successful
if command -v go &>/dev/null; then
    echo "Go installation complete. Version:"
    go version
else
    echo "Go installation failed."
fi
