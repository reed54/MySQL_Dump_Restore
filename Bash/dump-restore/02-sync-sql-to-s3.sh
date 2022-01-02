#!/bin/bash -p
#
#  Sychronize SQL files to S3 folder.
#
#
#   02-sync-sql-to-s3.sh: Synchronize files in /tmp/ directory to S3 bucket array-production-data
#
#   Centennial Data Science - James D. Reed April 29, 2021
#
#

LOGFILE="log/sync.-sql-to-s3.log"
RETAIN_NUM_LINES=100000

function logsetup {
    TMP=$(tail -n $RETAIN_NUM_LINES $LOGFILE 2>/dev/null) && echo "${TMP}" > $LOGFILE
    exec > >(tee -a $LOGFILE)
    exec 2>&1
}

function log {
        echo "[$(date --rfc-3339=seconds)]: $*"
}

logsetup
log "****************************************"
log "Begin 02-sync-sql-to-s3.sh"

DUMP_DIR=`cat latest`

BUCKET="matrix-dump-restore"
# Need to make sure target (destination folder exists on the bucket.

SOURCE="/tmp/${DUMP_DIR}/"
DEST="s3://${BUCKET}/rds/${DUMP_DIR}/"


log " "

log "----------------------------------------"
log "Synching ${SOURCE} to ${DEST} ... "
log "----------------------------------------"
log `aws s3 cp latest s3://${BUCKET}/rds/ --quiet`
log `aws s3 sync ${SOURCE} ${DEST} --quiet`

# Check destination files ...
log `aws s3 ls ${DEST} --recursive`
log "End   02-sync-sql-to-s3.sh"
log "****************************************"
log "  "
exit
