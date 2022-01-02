#!/bin/bash -p
#
#
# 03-restore_mysqldb.sh : Restore mysqldump. 
#
#   Centennial Data Science - James D. Reed May 10, 2021 
#
LOGFILE="log/restore-mysqldb.log"
RETAIN_NUM_LINES=100000
DSK_DIR=/tmp/rds
S3_LATEST="s3://${SRC_BUCKET}/rds/latest"


function logsetup {
    TMP=$(tail -n $RETAIN_NUM_LINES $LOGFILE 2>/dev/null) && echo "${TMP}" > $LOGFILE
    exec > >(tee -a $LOGFILE)
    exec 2>&1
}

function log {


	echo "[$(date --rfc-3339=seconds)]: $*"
}

function fetch_file {
	aws s3 cp ${S3_LATEST} latest --quiet
	if [[ -f "latest"   &&  ! -d $DSK_DIR/`cat latest` ]]; then 
	   		 mkdir -p ${DSK_DIR}/`cat latest`
    fi

	if [ -f "$DSK_DIR/`cat latest`/${db}" ]; then
    	echo "$DSK_DIR/`cat latest`/${db} exists. No need to download it from S3."
	else
	    echo "Download from S3 ${FILE}"
		aws s3 cp "s3://${SRC_BUCKET}/rds/`cat latest`/dump.sql" ${DSK_DIR}/`cat latest`/${db} --quiet
	fi

}

logsetup
log "****************************************"
log "Begin restore-mysqldb.sh"


# Destination folder where backups are stored
SRC_BUCKET="matrix-dump-restore"
DSK_DIR="/tmp/rds/"
S3_LATEST="s3://${SRC_BUCKET}/rds/latest"

db=dump.sql

FILE="s3://${SRC_BUCKET}/${DSK_DIR}/`cat latest`/${db}"
log "----------------------------------------" 
log "Restoring DB from $FILE ... "
log "-------------"
log `fetch_file`
log `DUMP=${DSK_DIR}/`cat latest`/${db}`
log "Restoring DB START from ${DUMP}"
mysql --protocol=tcp --port=3306  \
	--default-character-set=utf8 \
  	--comments  < ${DUMP}

log "restore-mysqldb.sh ${DUMP}  COMPLETE.  "

log "Databases restoration complete."

log "Complete execution restore-mysqldb.sh"
log "****************************************"
log "  "
exit
