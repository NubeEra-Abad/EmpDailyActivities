#!/bin/bash

# Check if Go is installed
if go version >/dev/null 2>&1; then
  echo "Go is already installed. Version:"
  go version
else
  echo "Go is not installed. Installing..."

  echo "Welcome to the Go installation script!"
  echo "Which version of Go would you like to install?"
  echo "1. Go 1.16"
  echo "2. Go 1.17"
  echo "3. Go 1.18"

  read -p "Enter your choice [1-3]: " choice

  # Install the specified version of Go
  case $choice in
    1)
      wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
      sudo tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz
      ;;
    2)
      wget https://golang.org/dl/go1.17.6.linux-amd64.tar.gz
      sudo tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
      ;;
    3)
      wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
      sudo tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
      ;;
    *)
      echo "Invalid Go version. Please choose 1, 2, or 3."
      exit 1
  esac

  # Add Go to the system path
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
  source ~/.profile

  echo "Go installation complete. Version:"
  go version
fi
