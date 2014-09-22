#!/bin/bash
#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------
#   tested on OVH Ftp server

# $ftphost $ftplogin $ftppw $ftpport $nameLogFile $pathBackup $ftproot
#   $1        $2      $3       $4        $5         $6          $7

echo "-- Data ftp transmission --" >>$5
numJour=`date +%u`

ftp -inv $1 $4 <<END_SCRIPT >>$5 2>&1
quote USER $2
quote PASS $3
binary
cd $7"/"${numJour}"/files"
mdelete *
lcd $6"/save/files"
mput *
cdup
cd www
mdelete *
lcd $6"/save/www"
mput *
cdup
cd mysql
mdelete *
lcd $6"/save/mysql"
mput *
quit
END_SCRIPT

echo "Exit connection: "$? >>$5
echo "********************************************************" >> $5
echo "Daily ftp repertory: "$numJour >>$5


