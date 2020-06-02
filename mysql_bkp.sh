#!/bin/bash

bkp_location="/backup/mysql" #Location in which backups need to be stored
host="rds.host.name.amazonaws.com" #RDS EndPoint
port="3306" #RDS Port
user="DB_user" #DB Username
passwd="DB_user_Passwd" #DB Password
db_name="DB_name" #DB Name which need to be backedup

date="$(date '+%d-%b-%Y-%H-%M-%S')"

mysqldump --single-transaction -h $host -P $port \
-u $user -p$passwd $db_name > $bkp_location/$date.sql