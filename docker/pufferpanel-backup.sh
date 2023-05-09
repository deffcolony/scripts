#!/bin/bash

# Set the pufferpanel container name
CONTAINER_NAME="pufferpanel"

# Set the backup directory
BACKUP_DIR="/home/gebruikersnaam/backups/pufferpanel"

# Create a new directory for the backup
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH="$BACKUP_DIR/$BACKUP_DATE"
mkdir -p "$BACKUP_PATH"

# Copy the pufferpanel directory's from the container to the backup directory
docker cp "$CONTAINER_NAME":/etc/pufferpanel "$BACKUP_PATH"
docker cp "$CONTAINER_NAME":/var/lib/pufferpanel "$BACKUP_PATH"

# Compress the backup directory
tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_DATE"

# Remove the uncompressed backup directory
rm -rf "$BACKUP_PATH"

# Prune old backups (keep the last 7 days)
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +7 -delete