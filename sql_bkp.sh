#!/bin/sh
### System Setup ###
NOW=`date +%Y-%m-%d`
KEEPDAYS=20
localBackup=/backups/mysql
#
### SSH Info ###
SHOST="ssh.yourhost.com"
SUSER="username"
SDIR="/backup/mysql"
        #
        ### MySQL Setup ###
        MUSER="username"
        MPASS="password"
        MHOST="hostname"
        DBS="SCHEMA1 SCHEMA2 SCHEMA3"
        #
        ### Start MySQL Backup ###
        attempts=0
        for db in $DBS                            # for each listed database
        do
                echo "Start $db"
                attempts=`expr $attempts + 1`           # count the backup attempts
                ssh -C $SUSER@$SHOST mkdir $SDIR/$NOW                   #create the backup dir
                FILE=$SDIR/$NOW/$db.sql.gz        # Set the backup filename
                                                    # Dump the MySQL and gzip it up
                ssh -C $SUSER@$SHOST "mysqldump -q -u $MUSER -h $MHOST -p$MPASS $db | gzip -9 > $FILE"
                echo "End $db"
        done
        ### Make local dir with today's date
        mkdir /"$localBackup"/$NOW
        scp -C $SUSER@$SHOST:/$SDIR/$NOW/* /backups/mysql/$NOW              # copy all the files to backup server
        ssh -C $SUSER@$SHOST rm -rf $SDIR/$NOW             # delete files on db server
                                                  # deleting of old files on backup
        ###########################################################################
        ################### Save last month's last backup (this month's first day) #########################
        ###########################################################################
        dayToKeep=`date +%d`
        if [ "$dayToKeep" = "01" ]; then
                permanents="/"$localBackup"/permanents/"
                cp -rl /"$localBackup"/$NOW $permanents
        fi

        # Deletes everything older than $KEEPDAYS days
        find "$localBackup" -type d -path "$permanents" -prune -o -daystart -mtime +$KEEPDAYS -exec rm -rf {} \;