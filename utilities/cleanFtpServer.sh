#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $$ &>/dev/null

formatTerm ()  # if $term one digit add "0"
{
    if [[ $term =~ ^.$  ]]  # if matching = true
    then
        term0="0"$term
    else
        term0=$term
    fi
}
# ------------------ main ---------------------------

# syntax checking of cleanFtpServer.sh: one optional arg
if [ $# -gt 1 ]
then
        echo "Usage: $0 [xxxx.conf] (default: ./cleanFtpServer.conf)"
        exit 2
fi

# default arg or not
if [ -n $* ]
then
	configuration=$*
fi
if [ -z $* ]
then
	configuration="cleanFtpServer.conf"
fi

# call configuration file
pathScript=`dirname $0`/
source ${pathScript}${configuration}

# manage empty variables
if [[ $ftpport == "" ]]
then
    ftpport="21"
fi

echo "Use "${pathScript}${configuration}
echo "Be careful, all data in the directory "${ftproot}
echo "and directory "${ftproot}" will be erased"
read -p "Do you want continue? (y,N) " reponse
if [ $reponse != "y" ]
then
	exit
fi

# delete subdirectory files, www, mysql and return ftproot directory
seq1="mdelete *\nmdelete files/*\nrmdir files\nmdelete www/*\nrmdir www\nmdelete mysql/*\nrmdir mysql\ncd /${ftproot}"

ftp -invp < <(
echo "open ${ftphost} ${ftpport}"
echo "user ${ftplogin} ${ftppw}"
echo "cd "${ftproot}

# daily backup
for ((d=1; d <= 7; d++))
do
    echo "cd d0"$d
    echo -e $seq1
    echo "rmdir d0"$d
done

# weekly backup
for ((term=1; term <= 22 ; term=`expr $term + 7`))
do
    formatTerm  # if $term one digit add "0"
    echo "cd w"$term0
    echo -e $seq1
    echo "rmdir w"$term0
done

# monthly backup
for ((term=1; term <= 12; term++))
do
    formatTerm
    echo "cd m"$term0
    echo -e $seq1
    echo "rmdir m"$term0
done

echo "cdup"
echo "rmdir "${ftproot}
echo "quit"
)


