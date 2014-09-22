#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $$ &>/dev/null



# syntax checking of backup.sh: one optional arg
if [ $# -gt 1 ]
then
        echo "Usage: $0 [configuration file name: xxxx.conf]"
        exit 2
fi

# default arg or not
if [ -n $* ]
then
	configuration=$*
fi
if [ -z $* ]
then
	configuration="hwsb.conf"
fi

# call configuration file
pathScript=`dirname $0`/
source ${pathScript}${configuration}

# manage empty variables
if [[ $mailhost == "" ]]
then
    mailhost="/etc/hostname"
fi
if [[ $pathsendmail == "" ]]
then
    pathsendmail="/usr/sbin/sendmail"
fi
if [[ $ftpport == "" ]]
then
    ftpport="21"
fi

# and construct log file name: $configuration = aaaa.bbb ->
# nameLogFile = $pathBackup + aaaa + .log
exreg="\([^\.]*\)"
nameLogFile=$pathBackup"/"`expr match "$configuration" $exreg`".log"
# delete the directory "save"
rm -rf $pathBackup"/save"
echo "---- Loaded configuration file: '"$configuration"' ----" >$nameLogFile
echo "---- HwsB backup "$(date "+%A %d/%m/%Y")" start at "$(date +%H:%M:%S)" ----" >>$nameLogFile

$pathScript"files-save.sh" $pathFileSave $nameLogFile $pathBackup 
$pathScript"site-save.sh" $pathSiteSave $nameLogFile $pathBackup  
$pathScript"data-dump.sh" $nupMysql $nameLogFile $pathBackup 
$pathScript"ftpback.sh" $ftphost $ftplogin $ftppw $ftpport $nameLogFile $pathBackup $ftproot

echo "---- End of backup at "$(date +%H:%M:%S)" ----" >>$nameLogFile

if [[ $mailto != "" ]]
then
     $pathScript"sendMail.sh" $mailto $mailhost $mailfrom $pathsendmail $nameLogFile $pathScript
fi
