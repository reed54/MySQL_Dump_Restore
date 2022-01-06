#!/bin/bash -p
#
#
# 01-backup-mysqldb.sh : Execute mysqldump on selected databases.  Output is one sql script per DB
#      that can be used to reconstitute the database in another environment.
#
#   Centennial Data Science - James D. Reed January 5, 2022
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

function get_db_list {
    SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN"
    SQL="${SQL} ('mysql', 'information_schema', 'performance_schema', 'sys')"

    DBLISTFILE=/tmp/databases_to_dump.txt
    mysql -ANe "${SQL}" > ${DBLISTFILE}

    DBLIST=""
    for DB in `cat ${DBLISTFILE}`  ; do DBLIST="${DBLIST} ${DB}" ; done

    echo ${DBLIST}
    return
}

logsetup
log "****************************************"
log "Begin backup-mysqldb.sh"

# Destination folder where backups are stored
DUMP_DIR=rds-$(date +"%Y-%m-%d")
DEST=/tmp/rds/${DUMP_DIR}
LDIR=/tmp/rds
echo ${DUMP_DIR} > ${LDIR}/latest

CURRDATE=$(date +"%F")

DBLIST=`get_db_list`
log `echo "DBLLIST: ${DBLIST}"`

[ ! -d ${DEST} ] && mkdir -p ${DEST}

FILE="${DEST}/dump.sql"
FILEDATE=$(date -r $FILE +"%F")

log "----------------------------------------"
log "Dumping DBs: ${DBLIST} to ${FILE} ... "
log "----------------------------------------"

[ -f ${FILE} ] && mv "${FILE}" "${FILE}.old"
log "Dumping DB START"
mysqldump --port=3306 --default-character-set=utf8 --databases  \
          --protocol=tcp --databases --triggers --routines \
          --events --column-statistics=0 --set-gtid-purged=OFF ${DBLIST} > "${FILE}"

log "Dumping DBs  COMPLETE.  "
rm -f "${FILE}.old"

echo "${DUMP_DIR}" > latest
log "Databases backup complete."


log `ls -lh ${DEST}/dump.sql`

log "Complete execution backup-mysqldb.sh"
log "****************************************"
log " "
exit
