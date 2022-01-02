#!/bin/bash -p
#
#
# 04-sync-efs-filesystems.sh : Sync EFS filesystems. 
#
#   Centennial Data Science - James D. Reed May 20, 2021 
#
LOGFILE="log/sync-efs-filesystems.log"
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
log "*************************************************************************************"
log "Begin sync-efs-filesystems.sh"

# Destination folder where backups are stored
SRC_BUCKET="array-production-data"

FS_ID=("fs-91d18096")
FS_DIR=("/mnt/arrhub")
FS_SRC="s3://${SRC_BUCKET}/EFS/fs-59b33ff3/"

#echo "FS_ID: ${FS_ID}, FS_DIR: ${FS_DIR}, FS_SRC: ${FS_SRC}"

log "--------------------------------------------------------------------------------------" 
log "Syncing filesystem ${FS_ID} from ${FS_SRC} ... "
log "-------------"

#log `aws s3 sync ${FS_SRC} ${FS_DIR}`
log `sudo s3cmd --recursive --preserve sync ${FS_SRC} ${FS_DIR}/`
log "sync-efs-filesystems.sh FS ${FS_ID}  COMPLETE.  "
log "****************************************************************************************"
exit
