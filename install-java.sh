#!/bin/bash

# Check if Java is installed
if java -version >/dev/null 2>&1; then
  echo "Java is already installed. Version:"
  java -version
else
  echo "Java is not installed. Installing..."

echo "Welcome to the Java installation script!"
echo "Which version of Java would you like to install?"
echo "1. Java 8"
echo "2. Java 11"
echo "3. Java 16"

read -p "Enter your choice [1-3]: " choice


  # Install the specified version of Java
  case $choice in
    1)
       apt-get update
       apt-get install openjdk-8-jdk
      ;;
    2)
       apt-get update
       apt-get install openjdk-11-jdk
      ;;
    3)
       apt-get update
       apt-get install openjdk-16-jdk
      ;;
    *)
      echo "Invalid Java version. Please choose 8, 11, or 16."
      exit 1
  esac
  
  echo "Java installation complete. Version:"
  java -version
fi
