#!/bin/bash

## This script runs on a root cronjob at 4AM daily.

timestamp="$(date +%Y-%m-%d_%H:%M)"

## NFS mount to NAS
backupDir=/mnt/lacustrine/Backups/$timestamp
logFile=$backupDir/../$timestamp'-Backup.log'

mkdir -p "$backupDir"
echo "$timestame"
echo "$backupDir"

## backup
# proc, sys, and dev ignored because they change as the OS runs and have nothing
# worth backing up.  /mnt is ignored as it's mostly remote mounts and the
# physical drives that are mounted I'm not worried about losing.  
rsync --exclude=/mnt/ --exclude=/sys/ --exclude=/proc/ --exclude=/dev -Pavz / "$backupDir" | tee -a "$logFile"
## Compress
tar -cjf "$backupDir.tar.bz2" "$backupDir" | tee -a "$logFile"
echo "Backup Compressed!"
echo "Removing directoy"
rm -rf "$backupDir"

echo "Completed backup!"

## Delete old backup plus a few incase computer is off for some time,Ex:moving
threeDays="$(date +%Y-%m-%d_%H:%M --date='-3 day')"
fourDays="$(date +%Y-%m-%d_%H:%M --date='-4 day')"
fiveDays="$(date +%Y-%m-%d_%H:%M --date='-5 day')"
sixDays="$(date +%Y-%m-%d_%H:%M --date='-6 day')"
sevenDays="$(date +%Y-%m-%d_%H:%M --date='-7 day')"

echo "Removing old backups"
# backups
rm -f "$threeDays.tar.bz2 $fourDays.tar.bz2 $fiveDays.tar.bz2 $sixDays.tar.bz2 $sevenDays.tar.bz2"
# logs
rm -f "$threeDays.log $fourDays.log $fiveDays.log $sixDays.log $sevenDays.log"
echo "Old backups removed"

## At this point I'll usually transfer a backup from every two weeks or so.
## For me normally this involves encrypting it, and then  GPG signing it
## while also publishing the signature.  It then gets uploaded to an
## off site storage, for me it gets sent up to GDrive (since I have unlimitted
## storage there).  Do you own thing here for offsite backups.
