#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

while getopts n:u:p:?h name
  do
    case $name in
    	n)
    	    nval="$OPTARG"
    	    ;;
        u)
            uval="$OPTARG"
            ;;  
        p)
            pval="$OPTARG"
            ;;
        ?,h)
            printf "Usage: %s: -n databaseName -u userName -p passWord [sqlFilesRepertory (default: ./sql)]\n" $0
            exit 2
            ;;
    esac
done

if [ $OPTIND -ne 7 ]
then
	printf "Usage: %s: -n databaseName -u userName -p passWord [sqlFilesRepertory (default: ./sql)]\n" $0
	exit 2
fi

shift $((OPTIND-1))

if [ -n $* ]
then
	pathSql=$*"/*.sql"
fi
if [ -z $* ]
then
	pathSql="./sql/*.sql"
fi

echo
echo "Database name: $nval"
echo "User, root if you want to create the database: you are $uval"
echo "Pass word of user $uval: -->$pval<--"
echo "*.sql files repertory is: $pathSql"
read -p "ok to proceed? (y,n) " reponse
if [ $reponse != "y" ]
then
	exit
fi
#----------------------------------------------------------------------------
renice 19 -p $$ &>/dev/null

log="errorSql.log"
: > $log
i=1;
e=0;

echo
echo "---Creating database---"
read -p "ok to creating $nval? (y,n) " reponse2
if [ $reponse2 = "y" ]
then
	echo "create database if not exists $nval;" | mysql -u$uval -p$pval 2>>$log
	if [ $? -gt 0 ] 
	then
		echo "Database not created! See errorSql.log"
		cat errorSql.log
		exit 2
	else
	echo "Database $nval created, or already exists."
	fi
fi

echo
echo "---Restoring database---"
for fichier in $pathSql
do
	echo -ne "\r                                                               "
	echo -ne "\r"$i" "$fichier;
	mysql -u$uval --password=$pval $nval < "$fichier" 2>>$log
	if [ $? -gt 0 ] 
	then
		e=`expr $e + 1`
		echo "    for the file "$fichier >>$log
	fi 
	i=`expr $i + 1`  ;
done
echo
echo "There are "$e" error(s), see errorSql.log";

