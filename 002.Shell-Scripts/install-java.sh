#!/bin/bash

# Check if Java is installed
if java -version >/dev/null 2>&1; then
  echo "Java is already installed. Version:"
  java -version
else
  echo "Java is not installed. Installing..."
  
  # Install the specified version of Java
  case "$1" in
    8)
       apt-get update
       apt-get install openjdk-8-jdk
      ;;
    11)
       apt-get update
       apt-get install openjdk-11-jdk
      ;;
    16)
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
