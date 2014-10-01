#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $$ &>/dev/null



# syntax checking of hwsb.sh: one optional arg
if [ $# -gt 1 ]
then
        echo "Usage: $0 [configuration file name: xxxx.conf]"
        exit 2
fi

# default arg or not, default = hwsb.conf
if [ -n $* ]
then
	configuration=$*
fi
if [ -z $* ]
then
	configuration="hwsb.conf"
fi

# call configuration file, the file in $pathScript
pathScript=`dirname $0`/
# ftpServerInit modified par conf file if already init
ftpServerInit=""
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

# backup period: sanitize parameters and construct the array
if [[ $dailyBackup == "on" ]]; then period[0]=1; else period[0]=0; fi
if [[ $weeklyBackup == "on" ]]; then period[1]=1; else period[1]=0; fi
if [[ $monthlyBackup == "on" ]]; then period[2]=1; else period[2]=0; fi

# and construct log file name: file conf = $configuration = aaaa.bbb ->
# nameLogFile = $pathBackup + aaaa + .log
exreg="\([^\.]*\)"
nameLogFile=$pathBackup"/"`expr match "$configuration" $exreg`".log"

# Verifies directory for save exist
if ! [ -d $pathBackup ]
then
    mkdir -p $pathBackup
fi

# delete the directory "save"
rm -rf $pathBackup"/save"

# log file header
echo "---- Loaded configuration file: '"$configuration"' ----" >$nameLogFile
echo -n "---- Backup period are: " >>$nameLogFile  # for period in $periods do ... done
[ ${period[0]} -eq 1 ] && echo -n "daily, ">>$nameLogFile  # list &&: execute echo if test is true
[ ${period[1]} -eq 1 ] && echo -n "weekly, ">>$nameLogFile
[ ${period[2]} -eq 1 ] && echo -n "monthly ">>$nameLogFile
echo "----">>$nameLogFile
echo "---- HwsB backup "$(date "+%A %d/%m/%Y")" start at "$(date +%H:%M:%S)" ----" >>$nameLogFile

# init the directories tree on ftp server if necessary
if [[ $ftpServerInit == "" ]]
then
    # `echo ${period[@]}` => pass all the array as an argument
    $pathScript"initFtpServer.sh" $ftphost $ftplogin $ftppw $ftpport $nameLogFile $ftproot `echo ${period[@]}`
    echo "ftpServerInit='ok'" >> ${pathScript}${configuration}
fi

$pathScript"files-save.sh" $pathFileSave $nameLogFile $pathBackup 
$pathScript"site-save.sh" $pathSiteSave $nameLogFile $pathBackup  
$pathScript"data-dump.sh" $nupMysql $nameLogFile $pathBackup 
$pathScript"ftpback.sh" $ftphost $ftplogin $ftppw $ftpport $nameLogFile $pathBackup $ftproot `echo ${period[@]}`

echo "---- End of backup at "$(date +%H:%M:%S)" ----" >>$nameLogFile

if [[ $mailto != "" ]]
then
     $pathScript"sendMail.sh" $mailto $mailhost $mailfrom $pathsendmail $nameLogFile $pathScript
fi
