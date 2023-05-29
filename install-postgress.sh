#!/bin/bash

# Check if PostgreSQL is installed
if ! command -v psql >/dev/null 2>&1; then
  echo "PostgreSQL is not installed. Installing..."

  echo "Welcome to the PostgreSQL installation script!"
  echo "Which version of PostgreSQL would you like to install?"
  echo "1. PostgreSQL 11.13"
  echo "2. PostgreSQL 12.8"
  echo "3. PostgreSQL 13.4"

  read -p "Enter your choice [1-3]: " choice

  # Install the specified version of PostgreSQL
  case $choice in
    1)
      sudo apt-get update
      sudo apt-get install postgresql-11.13
      ;;
    2)
      sudo apt-get update
      sudo apt-get install postgresql-12.8
      ;;
    3)
      sudo apt-get update
      sudo apt-get install postgresql-13.4
      ;;
    *)
      echo "Invalid PostgreSQL version. Please choose 1, 2, or 3."
      exit 1
  esac

  echo "PostgreSQL installation complete. Version:"
  psql --version
fi