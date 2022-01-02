#!/bin/bash -p
#
#
# get_file.sh 
#
#   Centennial Data Science - James D. Reed May 10, 2021 
#
LOGFILE="log/get_files.log"
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
log "Begin get_files.sh"

# Flush SQL files from local storage.
log `rm -v ${TMP_DIR}/*`


# Source of files in S3 
SRC_BUCKET="array-production-data"

# Directory on S3 holding the RDS files.
#DUMP_DIR='rds/rds-2021-05-22'
DUMP_DIR="rds/`cat latest`"

DATABASES="surveyengine ars edtrakv3 piwik userdb"

for db in $DATABASES; do
  	FILE="s3://${SRC_BUCKET}/${DUMP_DIR}/$db.sql"
	log "DB to be fetched: $db"
	log `fetch_file`
done

log "Complete execution get_files.sh"
log "****************************************************************************************"
exit
