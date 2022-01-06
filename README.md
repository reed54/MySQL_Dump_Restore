


![CDC 6600 (ca 1964)](img/CDC_6600_Overview.png)



# MySQL Dump Restore

This repository consists of _bash_ scripts and _Terraform_ configurations to implement infrastructure in **two** AWS accounts.  The purpose of which is to **mysqldump** an RDS instance in one account (SOURCE) and restore the resulting dumped databases in another account (TARGET) with a similar RDS instance.

## The  Process  

1. Clone this repository into your local workspace.

```
$ git clone git@github.com:reed54/MySQL_Dump_Restore.git
Cloning into 'MySQL_Dump_Restore'...
remote: Enumerating objects: 90, done.
remote: Counting objects: 100% (90/90), done.
remote: Compressing objects: 100% (61/61), done.
remote: Total 90 (delta 27), reused 85 (delta 26), pack-reused 0
Receiving objects: 100% (90/90), 2.72 MiB | 6.59 MiB/s, done.
Resolving deltas: 100% (27/27), done.
```

2. Collect parameters related to your AWS accounts.  Details about the SOURCE and TARGET accounts.  You will need the host strings of your RDS databases as well as root username and password.  Edit the appropriate **variables.tf** files.

### Source EC2 (Terraform/ec2/source_ec2/variables.tf)  

|  Variable         |     Description                                                |
|-------------------|----------------------------------------------------------------|
| region            | AWS region designation.  e.g., us-east-2                       |
| profile           | Profile within local ~/.aws/credentials file.                  |
| bucket_name       | This is generated automatically.     |
| amz-ubuntu-ami    | AMI for both SOURCE and TARGET EC2s                            |
| source_key_name   | Source EC2 key-pair.  The KP must exist before Terraform apply.|
| source_account    | Account number for SOURCE Account.                             |
| target_account    | Account number for TARGET Account.                             |
| vpc_id            | VPC ID where SOURCE RDS instance is located.                   |
| ec2_subnet_id     | Public Subnet within the VPC for the SOURCE RDS.               |
|                   |                                                                |

### Target EC2 (Terraform/ec2/target_ec2/variables.tf)  


|  Variable         |     Description                                                |
|-------------------|----------------------------------------------------------------|
| region            | TARGET AWS region designation.  e.g., us-east-2                |
| profile           | TARGET Profile within local ~/.aws/credentials file.           |
|                   |                                                                |
| amz-ubuntu-ami    | AMI for both SOURCE and TARGET EC2s                            |
| target_key_name   | Source EC2 key-pair.  The KP must exist before Terraform apply.|
| source_account    | Account number for SOURCE Account.                             |
| target_account    | Account number for TARGET Account.                             |
| vpc_id            | VPC ID where SOURCE RDS instance is located.                   |
| ec2_subnet_id     | Public Subnet within the VPC for the TARGET RDS.               |
|                   |                                                                |

If the user wishes to setup a complete test environments with two EC2 virtual machines AND small RDS instances, Terraform configurations are included in _Terraform/rds_.


3. Apply the information gathered in step #2 to the appropriate _variables.tf_ files.

```
$ cd MySQL_Dump_Restore/Terraform/ec2
$ ls */variables.tf
source_ec2/variables.tf  target_ec2/variables.tf
```

4. Deploy (terraform apply) the SOURCE EC2, S3 and the TARGET EC2.
```
$ cd MySQL_Dump_Restore/Terraform/ec2/source_ec2
$ terraform init
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

1. Preparations:
 - Make sure you have Key-Pairs for both the SOURCE and TARGET accounts.
 - Familiarize yourself with the VPC security gateways and route tables for your environments.
 - The Terraform configurations should help speed up the process.  Hopefully!


2. Clone this repository into a your local workspace.

   $ git clone https://github.com/reed54/MySQL_Dump_Restore.git

3. Parameters related to your accounts will have to be set in the Terraform configuration files.  Refer to the "Variable" tables above.


4.  If you have used Terraform before, here is a snippit of the process:

```
$ cd Terraform/source_ec2
# Edit variables.tf
$ terraform init
$ terraform plan
# Review the plan
$ terraform apply

$ cd ../target_ec2
# Repeat the steps above.
```

What follows is a step-by-step walkthrough using the Bash scripts to transfer the databases from SOURCE to TARGET.
    
 
    Centennial Data Science - James D. Reed April 28, 2021
## Backup the SOURCE Databases

### 01-backup_mysqldb.sh

```
ubuntu@ip-172-26-0-213:~/dump-restore$ ./01-backup_mysqldb.sh
[2022-01-03 21:29:53+00:00]: ****************************************
[2022-01-03 21:29:53+00:00]: Begin backup-mysqldb.sh
[2022-01-03 21:29:53+00:00]: DBLLIST: employees
[2022-01-03 21:29:53+00:00]: ----------------------------------------
[2022-01-03 21:29:53+00:00]: Dumping DBs: employees to /tmp/rds/rds-2022-01-03/dump.sql ...
[2022-01-03 21:29:53+00:00]: ----------------------------------------
[2022-01-03 21:29:53+00:00]: Dumping DB START
[2022-01-03 21:29:57+00:00]: Dumping DBs COMPLETE.
[2022-01-03 21:29:57+00:00]: Databases backup complete.
[2022-01-03 21:29:57+00:00]: -rw-rw-r-- 1 ubuntu ubuntu 161M Jan 3 21:29 /tmp/rds/rds-2022-01-03/dump.sql
[2022-01-03 21:29:57+00:00]: Complete execution backup-mysqldb.sh
[2022-01-03 21:29:57+00:00]: ****************************************
```

This script executes mysqldump on all of the databases in the RDS instance, except for the following databases:
+ mysql
+ information_schema 
+ performance_schema
+ sys

No arguments are required. A log file is appended to *backup-mysqldb.log*.  

## Synchronize the databases to the S3
### 02-sync-sql-to-s3.sh
This script syncronizes the latest backup to S3 **array-production-data**.

```
[ubuntu@ip-172-26-0-213:~/dump-restore$ ./02-sync-sql-to-s3.sh
[2022-01-03 21:46:44+00:00]: ****************************************
[2022-01-03 21:46:44+00:00]: Begin 02-sync-sql-to-s3.sh
[2022-01-03 21:46:44+00:00]:
[2022-01-03 21:46:44+00:00]: ----------------------------------------
[2022-01-03 21:46:44+00:00]: Synching /tmp/rds/rds-2022-01-03/ to s3://matrix-dump-restore/rds/rds-2022-01-03/ ...
[2022-01-03 21:46:44+00:00]: ----------------------------------------
[2022-01-03 21:46:44+00:00]:
[2022-01-03 21:46:46+00:00]:
[2022-01-03 21:46:47+00:00]: 2022-01-03 21:46:46 168375779 rds/rds-2022-01-03/dump.sql
[2022-01-03 21:46:47+00:00]: End   02-sync-sql-to-s3.sh
[2022-01-03 21:46:47+00:00]: ****************************************
[2022-01-03 21:46:47+00:00]:
```


## Restore SOURCE Databases onto TARGET RDS instance
### ./03-restore_mysqldb.sh
This script restores the dump of databases to the TARGET RDS instance.  Note, this step is completed from the TARGET EC2.

```
ubuntu@ip-172-26-0-213:~/dump-restore$ ./02-sync-sql-to-s3.sh
[2022-01-03 21:46:44+00:00]: ****************************************
[2022-01-03 21:46:44+00:00]: Begin 02-sync-sql-to-s3.sh
[2022-01-03 21:46:44+00:00]:
[2022-01-03 21:46:44+00:00]: ----------------------------------------
[2022-01-03 21:46:44+00:00]: Synching /tmp/rds/rds-2022-01-03/ to s3://matrix-dump-restore/rds/rds-2022-01-03/ ...
[2022-01-03 21:46:44+00:00]: ----------------------------------------
[2022-01-03 21:46:44+00:00]:
[2022-01-03 21:46:46+00:00]:
[2022-01-03 21:46:47+00:00]: 2022-01-03 21:46:46 168375779 rds/rds-2022-01-03/dump.sql
[2022-01-03 21:46:47+00:00]: End   02-sync-sql-to-s3.sh
[2022-01-03 21:46:47+00:00]: ****************************************
[2022-01-03 21:46:47+00:00]:
```
                     
## Your Feedback is Appreciated.

As is often said, hardware eventually breaks and software eventually works.  Let me know your experiences with this work in progress.

Jim Reed/Centennial Data Science  
jdreed1954@hotmail.com
