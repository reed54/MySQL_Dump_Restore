
# mysqlbackup-upload
Bash scripts to run mysqldump on  selected databases and upload SQL files to S3.

	Centennial Data Science - James D. Reed April 28, 2021
## 00-create-config.sh

This script allows the user to setup MySQL parameters:
  * **login path** - the parameter that determines which identity will be used.
  * **host** - this is the host string that will be used to access the database(s).
  * **user** - username used to log into the MySQL **host**.
  * **password** - this parameter is a placeholder to prompt for the password when the scripts is executed.

Once the _mysql_config_editor_ is executed the parameters have been encoded into file **.mylogin.cnf**.  For more information on this facility **mysql_config_editor** -- [MySQL Configuration Utility](https://dev.mysql.com/doc/refman/8.0/en/mysql-config-editor.html)


## 01-backup_mysqldb.sh

This scrip[t executes mysqldump on selected MySQL schemas (databases).  No arguments are required. A log file is appended to *backup-mysqldb.log*.  Run time on the current five databases takes less than ten minutes.:
    1. ars
    2. edtrakv3
    3. piwik
    4. surveyengine
    5. userdb

### Execution - log is echoed on standard output.:

    ** $ ./01-backup_mysqldb.sh**
     [2021-05-08 18:27:39+00:00]: *************************************************************************************
    [2021-05-08 18:27:39+00:00]: Begin backup-mysqldb.sh
    [2021-05-08 18:27:39+00:00]: DB to be dumped: ars
    [2021-05-08 18:27:39+00:00]: DB to be dumped: edtrakv3
    [2021-05-08 18:27:39+00:00]: DB to be dumped: piwik
    [2021-05-08 18:27:39+00:00]: DB to be dumped: surveyengine
    [2021-05-08 18:27:39+00:00]: DB to be dumped: userdb
    [2021-05-08 18:27:39+00:00]: --------------------------------------------------------------------------------------
    [2021-05-08 18:27:39+00:00]: Processing DB ars to /tmp/rds-2021-05-08/ars.sql ...
    [2021-05-08 18:27:39+00:00]: -------------
    [2021-05-08 18:27:39+00:00]: Dumping DB ars  START
    [2021-05-08 18:28:47+00:00]: Dumping DB ars  COMPLETE.
    [2021-05-08 18:28:47+00:00]: --------------------------------------------------------------------------------------
    [2021-05-08 18:28:47+00:00]: Processing DB edtrakv3 to /tmp/rds-2021-05-08/edtrakv3.sql ...
    [2021-05-08 18:28:47+00:00]: -------------
    [2021-05-08 18:28:47+00:00]: Dumping DB edtrakv3  START
    [2021-05-08 18:28:53+00:00]: Dumping DB edtrakv3  COMPLETE.
    [2021-05-08 18:28:53+00:00]: --------------------------------------------------------------------------------------
    [2021-05-08 18:28:53+00:00]: Processing DB piwik to /tmp/rds-2021-05-08/piwik.sql ...
    [2021-05-08 18:28:53+00:00]: -------------
    [2021-05-08 18:28:53+00:00]: Dumping DB piwik  START
	[2021-05-08 18:30:35+00:00]: Dumping DB piwik  COMPLETE.
	[2021-05-08 18:30:35+00:00]: --------------------------------------------------------------------------------------
	[2021-05-08 18:30:35+00:00]: Processing DB surveyengine to /tmp/rds-2021-05-08/surveyengine.sql ...
	[2021-05-08 18:30:35+00:00]: -------------
	[2021-05-08 18:30:35+00:00]: Dumping DB surveyengine  START
	[2021-05-08 18:31:15+00:00]: Dumping DB surveyengine  COMPLETE.
	[2021-05-08 18:31:15+00:00]: --------------------------------------------------------------------------------------
	[2021-05-08 18:31:15+00:00]: Processing DB userdb to /tmp/rds-2021-05-08/userdb.sql ...
	[2021-05-08 18:31:15+00:00]: -------------
	[2021-05-08 18:31:15+00:00]: Dumping DB userdb  START
	[2021-05-08 18:32:14+00:00]: Dumping DB userdb  COMPLETE.
	[2021-05-08 18:32:14+00:00]: Databases backup complete.
	[2021-05-08 18:32:14+00:00]: -rw-rw-r-- 1 ubuntu ubuntu 3.9G May 8 18:28 /tmp/rds-2021-05-08/ars.sql
	[2021-05-08 18:32:14+00:00]: -rw-rw-r-- 1 ubuntu ubuntu 287M May 8 18:28 /tmp/rds-2021-05-08/edtrakv3.sql
	[2021-05-08 18:32:14+00:00]: -rw-rw-r-- 1 ubuntu ubuntu 5.9G May 8 18:30 /tmp/rds-2021-05-08/piwik.sql
	[2021-05-08 18:32:14+00:00]: -rw-rw-r-- 1 ubuntu ubuntu 2.3G May 8 18:31 /tmp/rds-2021-05-08/surveyengine.sql
	[2021-05-08 18:32:14+00:00]: -rw-rw-r-- 1 ubuntu ubuntu 2.9G May 8 18:32 /tmp/rds-2021-05-08/userdb.sql
	[2021-05-08 18:32:14+00:00]: Complete execution backup-mysqldb.sh
	[2021-05-08 18:32:14+00:00]: ****************************************************************************************

## 02-Sync.sh
This script syncronizes the latest backup to S3 **array-production-data**.

### Execution - log is echoed on standard output.:

    **$ ./02-Sync.sh**
    [2021-05-08 18:34:43+00:00]: ****************************************************************************************
	[2021-05-08 18:34:43+00:00]: Begin 02-Sync.sh
	[2021-05-08 18:34:43+00:00]:
	[2021-05-08 18:34:43+00:00]: ----------------------------------------------------------------------------------------
	[2021-05-08 18:34:43+00:00]: Synching /tmp/rds-2021-05-08/ to s3://array-production-data/rds/rds-2021-05-08/ ...
	[2021-05-08 18:34:43+00:00]: -----------------------------------------
	[2021-05-08 18:39:10+00:00]:
	[2021-05-08 18:39:11+00:00]: 2021-05-08 18:34:45 4178245876 rds/rds-2021-05-08/ars.sql 2021-05-08 18:34:57 300651579 rds/rds-2021-05-08/edtrakv3.sql 2021-05-08 18:34:51 6251338573 rds/rds-2021-05-08/piwik.sql 2021-05-08 18:35:03 2439845545 rds/rds-2021-05-08/surveyengine.sql 2021-05-08 18:35:11 3049009811 rds/rds-2021-05-08/userdb.sql
	[2021-05-08 18:39:11+00:00]: End   02-Sync.sh
	[2021-05-08 18:39:11+00:00]: ****************************************************************************************




~                                                                                                                       ~                       
