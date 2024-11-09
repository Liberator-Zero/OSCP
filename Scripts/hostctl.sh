#!/bin/bash

# Directory to store backups
BACKUP_DIR="/backups"

# Function to create a backup of /etc/hosts
backup_hosts() {
    # Create the backup directory if it doesn't exist
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backup directory created at $BACKUP_DIR."
    fi

    # Generate a timestamped backup file name
    local backup_file="$BACKUP_DIR/hosts.$(date +%Y%m%d%H%M%S).bak"

    # Create the backup
    cp /etc/hosts "$backup_file"
    echo "Backup of /etc/hosts created at $backup_file."

    # Check for existing backups and keep only the 5 most recent
    local backup_count
    backup_count=$(ls -1 "$BACKUP_DIR"/hosts.*.bak 2>/dev/null | wc -l)

    if [ "$backup_count" -gt 5 ]; then
        # Remove the oldest backup
        local oldest_backup
        oldest_backup=$(ls -1t "$BACKUP_DIR"/hosts.*.bak | tail -n 1)
        rm "$oldest_backup"
        echo "Oldest backup removed: $oldest_backup"
    fi
}

# Function to revert to the most recent backup
revert_hosts() {
    local latest_backup
    latest_backup=$(ls -t "$BACKUP_DIR"/hosts.*.bak 2>/dev/null | head -n 1)

    if [ -z "$latest_backup" ]; then
        echo "No backup file found for /etc/hosts."
        exit 1
    fi

    # Restore the most recent backup
    cp "$latest_backup" /etc/hosts
    echo "Restored /etc/hosts from backup: $latest_backup"
}

# Main logic to handle arguments
if [ "$1" == "--revert" ]; then
    # Revert to the most recent backup
    revert_hosts
    exit 0
elif [ "$#" -ne 2 ]; then
    # Check if two arguments are provided for adding an entry
    echo "Usage: hostctl <IP> <hostname> or hostctl --revert"
    exit 1
fi

IP=$1
HOSTNAME=$2

# Check if the entry already exists
if grep -q "^$IP $HOSTNAME$" /etc/hosts; then
    echo "Entry $IP $HOSTNAME already exists in /etc/hosts."
    exit 0
fi

# Create a backup before making changes
backup_hosts

# Append the IP and hostname to /etc/hosts
echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts >/dev/null

echo "Entry $IP $HOSTNAME added to /etc/hosts."