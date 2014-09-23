#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $$ &>/dev/null

# $ftphost $ftplogin $ftppw $ftpport $nameLogFile $ftproot
#   $1        $2      $3       $4        $5         $6

echo "---- Directories tree initialization on ftp server ----" >>$5

seq1="mdelete *\nmkdir files\nmdelete files/*\nmkdir www\nmdelete www/*\nmkdir mysql\nmdelete mysql/*\ncdup"

ftp -inv < <(
echo "open ${1} ${4}"
echo "user ${2} ${3}"
echo "mkdir $6"
echo "cd $6"
echo "mdelete *"
echo "mkdir 1"
echo "mkdir 2"
echo "mkdir 3"
echo "mkdir 4"
echo "mkdir 5"
echo "mkdir 6"
echo "mkdir 7"
echo "cd 1"
echo -e $seq1
echo "cd 2"
echo -e $seq1
echo "cd 3"
echo -e $seq1
echo "cd 4"
echo -e $seq1
echo "cd 5"
echo -e $seq1
echo "cd 6"
echo -e $seq1
echo "cd 7"
echo -e $seq1
echo "exit"
) >>$5 2>&1

echo "Exit connection: "$? >>$5
echo "The directory "$6" is ready" >>$5
echo "---- End of initialization ----" >>$5
echo >>$5