#!/usr/bin/env bash
set -euo pipefail

# Enable necessary services
systemctl enable nftables.service

# Prepare directories
cd / || { echo "Can't change directory to /"; exit 1; }

# Create snapshot subvolume
btrfs subvolume create /snapshots

# Create base snapshot dir
mkdir -p /snapshots/raw /snapshots/archives


# Backup and recreate /etc as Btrfs subvolume
if [ -d /etc ]; then
    mv /etc /etc.bak
    btrfs subvolume create /etc
    cp -a /etc.bak/. /etc/
    rm -rf /etc.bak
else
    echo "/etc not found!"
    exit 1
fi

# Snapshot the new /etc subvolume
BAK="etc.base.$(date +%Y%m%d.%H%M%S)"
btrfs subvolume snapshot -r "/etc" "/snapshots/raw/${BAK}"

# Archive the snapshot with gzip
ARCHIVE="/snapshots/archives/${BAK}.btrfs.gz"
btrfs send "/snapshots/raw/${BAK}" | gzip -c > "${ARCHIVE}" || {
    echo "Failed to create archive"
    exit 1
}

echo "Backup complete: ${ARCHIVE}"
