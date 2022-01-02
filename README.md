
# MySQL Dump Restore

This repository consists of _bash_ scripts and _Terraform_ configurations to implement infrastructure in **two** AWS accounts.  The purpose of which is to **mysqldump** and RDS instance in one account (SOURCE) and restore the same database in another account (TARGET) with a similar RDS instance.

## High-Level Process  

1. Clone this repository into your local workspace.

2. Collect parameters related to your AWS accounts.  Details about the SOURCE and TARGET accounts, the name of the S3 bucket to be used as destination/source of the database dump.  You will need the host strings of your RDS databases as well as root username and password.

3. Apply the information gathered in step #2 to the appropriate _variables.tf_ files.

```
$ cd MySQL_Dump_Restore/Terraform/ec2
$ ls */variables.tf
source_ec2/variables.tf  target_ec2/variables.tf
```

4. Deploy (terraform apply) the SOURCE EC2, S3 and the TARGET EC2.
```
$ cd MySQL_Dump_Restore/Terraform/ec2/source_ec2
$ terraform plan
$ terraform apply
```

5. Login to the SOURCE EC2 and setup the _~/.my.cnf_ according to the prototype to gain access to the SOURCE RDS instance.

6. On the SOURCE EC2, execute the backup script **01-backup_mysqldb.sh**.

7. Deploy (terraform apply) the TARGET EC2.
```
$ cd MySQL_Dump_Restore/Terraform/ec2/target_ec2
$ terraform plan
$ terraform apply
```

8. Login to the TARGET EC2 and setup the _~/.my.cnf_ according to the prototype to gain access to the TARGET RDS instance.  After this you should be able to access the RDS by simply typing:  

```
$ mysql  
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 22  
Server version: 5.7.12 MySQL Community Server (GPL)  

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.  

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.  
```
```
MySQL [(none)]` show databases;`  
+--------------------+  
| Database           |    
+--------------------+    
| information_schema |    
| employees          |    
| mysql              |    
| performance_schema |    
| sys                |    
+--------------------+    
5 rows in set (0.00 sec)    

MySQL [(none)]>
```
9.  Still logged into the SOURCE EC2, execute the **02-sync-sql-to-s3.sh** script.
```
$ cd dump-restore
$ ./02-sync-sql-to-s3.sh
[2022-01-01 23:25:53+00:00]: ****************************************
[2022-01-01 23:25:53+00:00]: Begin 02-sync-sql-to-s3.sh
[2022-01-01 23:25:53+00:00]: ----------------------------------------
[2022-01-01 23:25:53+00:00]: Synching /tmp/rds-2022-01-01/ to s3://matrix-dump-restore/rds/rds-2022-01-01/ ...
[2022-01-01 23:25:53+00:00]: ----------------------------------------
[2022-01-01 23:25:54+00:00]:
[2022-01-01 23:25:54+00:00]:
[2022-01-01 23:25:55+00:00]: 2022-01-01 21:31:45 172404810 rds/rds-2022-01-01/dump.sql
[2022-01-01 23:25:55+00:00]: End   02-sync-sql-to-s3.sh
[2022-01-01 23:25:55+00:00]: ****************************************
[2022-01-01 23:25:55+00:00]:
```

10. Login to the TARGET EC2 and execute the **02-restore_mysqldb.sh**
```
$ cd dump-restore


```

## Detailed Instructions

1. Clone this repository into a your local workspace.

   $ git clone https://github.com/reed54/MySQL_Dump_Restore.git

2. Parameters related to your accounts will have to be set in the Terraform configuration files.

    a. Your region, e.g., "us-west-2"  
    
    b. The profile of the CLI access to the SOURCE account (inside your **~/.aws/credentials**).  By default this set to "SOURCE."  

    c. The bucket name which will be used for the dump/restore location.  A policy will be applied to this bucket to allow both SOURCE and TARGET accounts access to this S3.

    d.



After cloning this repository onto a user workstation

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
