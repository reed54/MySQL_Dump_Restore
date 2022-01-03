#!/bin/bash

# 
# Collect all database names except for
# mysql, information_schema, sys, and performance_schema
#
SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN"
SQL="${SQL} ('mysql', 'information_schema', 'performance_schema', 'sys')"

DBLISTFILE=/tmp/databases_to_dump.txt
mysql -ANe "${SQL}" > ${DBLISTFILE}

DBLIST=""
for DB in `cat ${DBLISTFILE}`  ; do DBLIST="${DBLIST} ${DB}" ; done

echo ${DBLIST}

