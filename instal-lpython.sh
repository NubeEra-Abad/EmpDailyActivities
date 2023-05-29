#!/bin/bash

# Check if Python is installed
if python3 --version >/dev/null 2>&1; then
  echo "Python is already installed. Version:"
  python3 --version
else
  echo "Python is not installed. Installing..."

  echo "Welcome to the Python installation script!"
  echo "Which version of Python would you like to install?"
  echo "1. Python 3.8"
  echo "2. Python 3.9"
  echo "3. Python 3.10"

  read -p "Enter your choice [1-3]: " choice

  # Install the specified version of Python
  case $choice in
    1)
       apt-get update
       apt-get install python3.8
      ;;
    2)
       apt-get update
       apt-get install python3.9
      ;;
    3)
       apt-get update
       apt-get install python3.10
      ;;
    *)
      echo "Invalid Python version. Please choose 3.8, 3.9, or 3.10."
      exit 1
  esac
  
  echo "Python installation complete. Version:"
  python3 --version
fi
