#!/bin/bash

# Set the ispy container name
CONTAINER_NAME="ispy"

# Set the backup directory
BACKUP_DIR="/home/gebruikersnaam/backups/ispy"

# Create a new directory for the backup
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH="$BACKUP_DIR/$BACKUP_DATE"
mkdir -p "$BACKUP_PATH"

# Copy the ispy directory's from the container to the backup directory
docker cp "$CONTAINER_NAME":/agent/Media/XML "$BACKUP_PATH"
docker cp "$CONTAINER_NAME":/agent/Commands "$BACKUP_PATH"

# Compress the backup directory
tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_DATE"

# Remove the uncompressed backup directory
rm -rf "$BACKUP_PATH"

# Prune old backups (keep the last 7 days)
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +7 -delete