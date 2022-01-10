#!/bin/bash

port=`terraform output this_rds_cluster_port`
endpoint=`terraform output this_rds_cluster_endpoint`
username=`terraform output this_rds_cluster_master_username`
userpw=`terraform output this_rds_cluster_master_password`


echo "[client]"           > .my.cnf
echo "port=$port"        >> .my.cnf
echo "host=$endpoint"    >> .my.cnf
echo "user=$username"    >> .my.cnf
echo "password=$userpw"  >> .my.cnf

cat .my.cnf
