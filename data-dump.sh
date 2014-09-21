#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $$ &>/dev/null

# parse parameters
i=0
for param in $*
do
    nupMysql[$i]=$param
    ((i++))
done

# for 2 bases (7-1)/3=2
nbrBases=$((i/3))

# the last parameter and the next to last
pathBackup=${nupMysql[((--i))]}"/save/mysql/"
pathBackupSql=$pathBackup"sql/"
log=${nupMysql[((--i))]}

# digit+$row = index,
# 1st base index = digit (0 to 2) + 0, (name, user, pw)
# 2nd base digit (0 to 2) + 3 ... for each base (until $z less than $nbrBase: for 2 bases int of (8/3=2)
z=0
row=0
while [ "$z" -lt "$nbrBases" ]
do
    # Verifies that exists /save/mysql/sql
    if ! [ -d $pathBackupSql ]
    then
        mkdir -p $pathBackupSql
    fi

    pw=${nupMysql[$((2+$row))]}
    user=${nupMysql[$((1+$row))]}
    db=${nupMysql[$((0+$row))]}

    echo "-- Dump of the dataBase "$db" --" >>$log

    liste=`mysqlshow -u$user --password=$pw $db`
    liste2=`echo "$liste" |  awk -F "|" 'NR == 4 , NR == $NR { $1 = ""; print }'`

    tableau=( `echo $liste2`)  # especially not =($liste2) Penelope's syndrome ;)
    nbrTables=${#tableau[*]}   # = nbr of tables +1   (${#tableau[*]} -1) = syntax error???
    for element in $(seq 0 $(($nbrTables -1)))
    do
            nameTableFile="${pathBackupSql}${tableau[$element]}.sql"
            mysqldump --opt -u$user --password=$pw $db ${tableau[$element]} > $nameTableFile
            echo "Exit mysqldump of "${tableau[$element]}": "$? >>$log
    done
    cd $pathBackup
    tar -czf ${db}.sql.tgz sql 2>>$log
    wait ${!}
    echo "Exit tar: "$? >>$log
    rm -fr $pathBackupSql
    echo "Exit rm: "$? >>$log

    ((z++))
    ((row += 3))
done
exit

