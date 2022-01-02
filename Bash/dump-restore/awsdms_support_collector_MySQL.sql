
tee AWS_DMS_Support_Collector_for_MySQL.log 

##########################################################################################################################################################
##AWS DMS Support Collector for MySQL                                                                                                                   ##
##                                                                                                                                                      ##
##Version 1.0                                                                                                                                           ##	
##                                                                                                                                                      ##
##                                                                                                                                                      ##
##This script will collect information on a databases to help troubleshoot issues when using it with the DMS service.                                   ##	
##                                                                                                                                                      ##
##Before running the script, please read and understand the sql which will be executed from both a performance and security perspective.                ##
##                                                                                                                                                      ##
##Any part of this script may be removed or commented out to prevent that information from being included.                                              ##	
##                                                                                                                                                      ##
##Once the script is complete, it will display text output file AWS_DMS_Support_Collector_For_MySQL.log                                                 ##		
##                                                                                                                                                      ##
##                                                                                                                                                      ##
##                                                                                                                                                      ##
##                                                                                                                                                      ##
##For more information on MySQL compatible source and target migratation, Please refer                                                                  ##									
##                                                                                                                                                      ##		
##For Source : https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MySQL.html                                                                  ##
##                                                                                                                                                      ##
##For Target : https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.MySQL.html                                                                  ##
##########################################################################################################################################################


select "This script will collect information on a databases to help troubleshoot issues when using it with the DMS service." As "AWS DMS SUPPORT COLLECTOR FOR MySQL:VERSION 1";


############################
#    CONTENTS              #	
############################

##############################################
#1. Overview                                 #
#                                            #				
#2. Database Configuration                   #			
#   a) Database Name                         #			
#   b) Database Size                         #				
#   c) Database Version                      #			
#   d) Database Objects Count	             #
#                                            #
#3. Important Database Variables             #
#                                            #
#4. Table Detail                             #			
#   a) Tables Detail by Size                 #	
#   b) Tables Without Primary Key            #		
#   c) Tables With LOB columns               #	
#   d) Tables With Unsupported Datatypes     #	
#   e) Tables Without InnoDB engine          #	
#                                            #		
#5. Binary log Section                       #		
#   a) Binary log retention                  #
#   b) Show Binary Log Status                #
#                                            #
#6. Miscellaneous Information                #	
#   a)Storage Engine Detail                  #			
#   b)Network Parameters                     #			
#   c)Character Set Detail                   #  
#   d)Collation Detail                       #
#   e)Timezone Detail                        #			
#   f)SQL Mode                               #					
#   g)Slow Query Log and General Log         #
#   h)Replication Status                     #		
##############################################

####################################################################
#SECTION 1 : OVERVIEW                                              #	
#                                                                  #	
#This is the output from the DMS Support script for MySQL.         #
#Please upload this to AWS Support via a Customer Support Case.    #
####################################################################


select "This is the output from the DMS Support script for MySQL database. Please upload this to AWS Support via a Customer Support Case." As "SECTION 1: OVERVIEW";

##Report Generation Time##


select now(),"Report Start Time" As "DESCRIPTION";


####################################################################
#                                                                  #	
#SECTION 2 : DATABASE CONFIGURATION                                #	
#                                                                  #	
####################################################################

##Database Configurations##

Select "Show variables like Version and Database Name and Database Size " AS "SECTION 2 : DATABASE CONFIGURATION";

##Database Name and Database Size##

SELECT table_schema AS "Database", 
ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)","Database Size" AS "Description"
FROM information_schema.TABLES
where  table_schema = (select database())
GROUP BY table_schema;

select @@version "Database Version";

Select "Table,View and Stored Routines Count In The Database"  As "Object Detail in The Database";

select (select count(*) from information_schema.tables where table_schema=(select database())) as "Table Count",
(select count(*) from information_schema.views where table_schema=(select database())) as "View Count",
(select count(*) from information_schema.routines where routine_schema=(select database())) As "Routine Count";


####################################################################
#                                                                  #	
#SECTION 3 : IMPORTANT DATABASE VARIABLES                          #	
#                                                                  #	
####################################################################


select "Database variables and their values related to DMS CDC working properl"  AS "SECTION 3: IMPORTANT DATABASE VARIABLES";

show variables like 'log_bin';
select @@server_id into @a;
select "server_id",if (@a > 0,"TRUE","FALSE") "Configured Properly";
show variables like 'binlog_format';
show variables like 'binlog_checksum';
show variables like 'binlog_row_image';
show variables like 'log_slave_updates';


#If your source uses the NDB (clustered) database engine, the following parameters must be configured to enable CDC on tables that use that storage engine. Add these changes in MySQL's my.ini (Windows) or my.cnf (UNIX) file.#

select "For NDB (clustered) : please configure ndb_log_bin, ndb_log_update_as_write and ndb_log_updated_only parameters " AS "NDB CLUSTER SETTINGS";


show variables like 'ndb_log_bin';
show variables like 'ndb_log_update_as_write';
show variables like 'ndb_log_updated_only';



####################################
#SECTION 4 : TABLE DETAIL          #	 
####################################

Select " List of Tables : By Size, Without Primary Key, With LOB Column, Non-supported data type, Non-InnoDB" As "SECTION 4 : TABLE DETAIL ";


#Top 25 Tables based on size#

Select "Table and Its Size" As "TOP 25 TABLES";

SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)", "Table Size" As "Description"
FROM information_schema.tables
WHERE table_schema = (select database())
ORDER BY (data_length + index_length) DESC
limit 25;

#Tables without Primary Key#

select "Result set will be empty if all tables have a primary key" As "Tables Without Primary Key";

SELECT 
    t.table_name,"No Primary Key" As "Description"
FROM information_schema.TABLES t
LEFT JOIN information_schema.KEY_COLUMN_USAGE AS c 
ON (
       t.TABLE_NAME = c.TABLE_NAME
   AND c.CONSTRAINT_SCHEMA = t.TABLE_SCHEMA
   AND c.constraint_name = 'PRIMARY'
)
WHERE 
    t.table_schema <> 'information_schema'
AND t.table_schema <> 'performance_schema'
AND t.table_schema <> 'mysql'
AND c.constraint_name IS NULL
and t.table_schema=(select database());



#Table with LOB Column in current database#

select "Result set will be empty if no tables use LOB columns." As "Tables With LOB Column";

select Table_name,column_name,Data_Type,"Table With LOB" As "Description" from information_schema.columns 
where table_schema in (select database()) and data_type in ('json','longtext','mediumtext','longblob','mediumblob');


#List of non-supported datatypes and its tables#

Select "Result set will be empty if all tables have supported data type." As "List of non-supported data type and its tables";


select table_name,column_name,data_type,"Table with non supported data type" As "Description" from information_schema.columns 
where table_schema in (select database()) and data_type in ('time','float','geometry','point','linestring','polygon','multilinestring','multipolygon','geometrycolletion','enum','set');


#List of non INODB Engine Tables  - AWS DMS creates target tables with the InnoDB storage engine by default. If you need to use a storage engine other than InnoDB, you must manually create the table and migrate to it using do nothing mode.#

Select "Tables with Non InnoDB Engine - Refer documentation for limitation" As "Tables with Non InnoDB Engine";

select table_name,"Table with non InnoDB Engine" As "Description" from information_schema.tables where ENGINE<>'InnoDB' and table_schema in (select database());

##############################################################
# SECTION 5 : BINARY LOG SECTION                             #
##############################################################

select "Binary Log Information" As "SECTION 5 ";

#Binary log retention - below query will fail if its not RDS#

Select "AWS Hosted Database Configuration- call mysql.rds_show_configuration: This will fail for non RDS DB " As "Description";

call mysql.rds_show_configuration;

select "Listing of binary logs on server" as "Binary Log Information";

show binary logs;


##############################################################
# SECTION 6 : MISCELLANEOUS INFORMATION                      #
##############################################################

select "MISCELLANEOUS INFORMATION" As "SECTION 6 ";

#Storage Engine Detail#

Select "Storage Engine Detail" As "Description";

show variables like  '%engine%';

#NetTimeout Parameters#

Select "Network Related Parameters" AS "DESCRIPTION";

show variables  like 'net_read_timeout';
show variables  like 'net_write_timeout';
show variables  like 'wait_timeout';
show variables  like 'interactive_timeout';

#Character Set Detail#

Select "Character Set Detail - helps better understand the data" As "DESCRIPTION";

show  variables LIKE 'character_set\_%';

Select "Collation Detail - helps better understand the data" As "DESCRIPTION";

show variables like '%collation%';

Select "Timezone Detail - helps better understand the data" As "DESCRIPTION";

show variables like '%zone%';

#Max Connection#

show variables like "%connections%";

show global status like 'aborted_connects';

#SQL Mode of the DB#

show variables like '%sql_mode%';

show variables like 'slow_query_log';

show variables like 'general_log';

#Replication Status#

Select "Note: Show master status output and show slave status is to understand the replication status if configured" As "Replication Status Section";


Select "show master status output" As "Replication Status";

show master status;

Select "Show slave status output" As "Replication Status";

show slave status;

Select "Thank you for using MySQL support bundle,if any concern with any query output,please remove it before uploading." As "INFORMATION";

Select "Source: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MySQL.html " AS "For more information on MySQL compatible source refer to the link below.";


Select now(), "Report End Time" as "DESCRIPTION";

notee 
