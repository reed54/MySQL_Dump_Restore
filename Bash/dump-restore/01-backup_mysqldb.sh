#!/bin/bash -p
#
#
# 01-backup-mysqldb.sh : Execute mysqldump on selected databases.  Output is one sql script per DB
#      that can be used to reconstitute the database in another environment.
#
#   Centennial Data Science - James D. Reed December 30, 2021
#
LOGFILE="log/backup-mysqldb.log"
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
log "Begin backup-mysqldb.sh"

# Destination folder where backups are stored
DUMP_DIR=rds-$(date +"%Y-%m-%d")
DEST=/tmp/${DUMP_DIR}
echo ${DUMP_DIR} > ${DEST}/latest

CURRDATE=$(date +"%F")



[ ! -d $DEST ] && mkdir -p $DEST

FILE="${DEST}/dump.sql"
FILEDATE=$(date -r $FILE +"%F")

log "----------------------------------------"
log "Processing All DBs to $FILE ... "
log "----------------------------------------"
# Be sure to make one backup per day
#[ -f $FILE ] && FILEDATE=$(date -r $FILE +"%F")
#[ "$FILEDATE" == "$CURRDATE" ] && continue

[ -f ${FILE} ] && mv "${FILE}" "${FILE}.old"
log "Dumping DB START"
mysqldump --port=3306 --default-character-set=utf8 \
          --protocol=tcp --triggers --routines --events \
          --column-statistics=0 --all-databases > "${FILE}"

log "Dumping DB COMPLETE.  "
rm -f "${FILE}.old"

echo "${DUMP_DIR}" > latest
log "Databasexs backup complete."


log `ls -lh ${DEST}/dump.sql`

log "Complete execution backup-mysqldb.sh"
log "****************************************"
log " "
exit
