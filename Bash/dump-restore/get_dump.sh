#!/bin/bash -p
#
#
# get_dump.sh 
#
#   Centennial Data Science - James D. Reed May 10, 2021 
#
LOGFILE="log/get_dump.log"
RETAIN_NUM_LINES=100000
TMP_DIR=/tmp/rds


function logsetup {
    TMP=$(tail -n $RETAIN_NUM_LINES $LOGFILE 2>/dev/null) && echo "${TMP}" > $LOGFILE
    exec > >(tee -a $LOGFILE)
    exec 2>&1
}

function log {


	echo "[$(date --rfc-3339=seconds)]: $*"
}

function fetch_file {
	[ ! -d $TMP_DIR ] && mkdir -p $TMP_DIR
	if [[ -f "$TMP_DIR/${db}" ]]; then
    		echo "$TMP_DIR/${db} exists. No need to download it from AWS."
	else
		echo "Download from AWS S3 ${FILE}"
		aws s3 cp ${FILE} ${TMP_DIR}/${db}
	fi

}

logsetup
log "*************************************************************************************"
log "Begin get_dump.sh"

# Flush SQL files from local storage.
log `rm -v ${TMP_DIR}/*`


# Source of files in S3 
SRC_BUCKET="matrix-dump-restore"

# Directory on S3 holding the RDS files.
DUMP_DIR="rds/`cat latest`"


FILE="s3://${SRC_BUCKET}/${DUMP_DIR}/dump.sql"
log "DB to be fetched: dump.sql"
log `fetch_file`

log "Complete execution get_dump.sh"
log "****************************************************************************************"
exit
