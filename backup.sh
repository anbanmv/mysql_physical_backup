#!/bin/bash
# Bash script to backup MySQL database - Physical backup
# Author: Anban Malarvendan
# License: GNU GENERAL PUBLIC LICENSE Version 3 + 
#          Section 7: Redistribution/Reuse of this code is permitted under the 
#          GNU v3 license, as an additional term ALL code must carry the 
#          original Author(s) credit in comment form.

# Database user credentials
DB_USER="backup_user"
DB_PASSWORD="password"

# Paths for backup and log files
BACKUP_PATH="/path/to/save/backups"
LOG_FILE="/path/to/save/logs/percona_log.txt"

# Perform the database backup using innobackupex utility - Initiate backup
innobackupex --user="$DB_USER" --password="$DB_PASSWORD" "$BACKUP_PATH" >&"${LOG_FILE}"

# Check the status of the backup
BACKUP_STATUS=$(grep 'NOTE: Backup successful' "${LOG_FILE}" | wc -l)

if [ "$BACKUP_STATUS" -eq 2 ]; then
    # If backup is successful, notify via email
    printf "Success - Full backup taken on `hostname`." | mailx -r root@clientname.com -s "FULL BACKUP SUCCESS: `hostname`" mail@yourdomain.com

    # Clean up old backups (older than 7 days)
    cd "$BACKUP_PATH"
	rm -rf $(date --date='7 days ago' +%Y-%m-%d)*
else
    # If backup fails, notify via email and check logs for errors
    printf "Please check backup logs for errors." | mailx -r user_root@yourdomain.com -s "ERROR: BACKUP HAS FAILED ON: `hostname`" mail@yourdomain.com
fi
