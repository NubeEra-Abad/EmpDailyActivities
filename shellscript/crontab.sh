#!/bin/bash

# This is a shell script that performs some task that needs to be run periodically, such as backing up a database.

# Set variables
DB_NAME="my_database"
BACKUP_DIR="/var/backups/my_database"

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

# Create backup file name with timestamp
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$(date +%Y-%m-%d-%H-%M-%S).sql"

# Use mysqldump to create backup of database
mysqldump -u root -p my_database > "$BACKUP_FILE"

# Print success message
echo "Backup of $DB_NAME saved to $BACKUP_FILE on $(date)."
