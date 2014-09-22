#!/bin/bash 

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

# $mailto $mailhost $mailfrom $pathsendmail $nameLogFile $pathScript
#    $1     $2         $3         $4           $5           $6

log=$5

printf "%s\n" "-- Sends mail --" >>$log

# Config 
file=$6"/sysnotify.mail"   # use scripts directory to write mail
nomHost=`cat $2`
from=$3
to=$1
pathsendmail=$4

# mail header 
printf "Return-Path: <>\nFrom: Notification system <$from>\nTo: $to\nSubject: About $nomHost\nMIME-Version:1.0\nContent-Type: multipart/mixed; boundary=\"MAIL_BOUNDARY\"\nContent-Transfer-Encoding: 8bit\nX-Priority: 1\nX-MSMail-Priority:High\n" >$file

# mail message 
printf "\n--MAIL_BOUNDARY\nContent-Type: text/plain; charset=\"UTF-8\"\nContent-Transfer-Encoding: 8bit\n\n" >>$file  #iso-8859-1
printf "Hi,\n\nThis is an automated email from $nomHost, \nServer backup by HswB\n\n\n" >>$file
printf "Backup $(date +%Y/%m/%d) at $(date +%H:%M:%S): the process completed, see below the overview\n\n" >>$file
printf "Backup log:\n\n" >>$file
textLog=$(cat $log)
printf "%s\n" "$textLog" >>$file
# attach 
#printf "\n--MAIL_BOUNDARY\nContent-Type: text/plain; name=\"backup.log\"\nContent-Transfer-Encoding: 8bit\nContent-Disposition:
#attachment; filename=\"/root/\"\n\n" >>$file 

printf "\n\n--MAIL_BOUNDARY--" >>$file 

# send mail 
$pathsendmail -t < $file 2>>$log

printf "%s\n" "Exit mail transmission: "$? >>$log
